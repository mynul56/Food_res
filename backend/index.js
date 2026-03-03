const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { getStorage } = require("firebase-admin/storage");
admin.initializeApp();

const bucket = getStorage().bucket();

// A simple function that runs whenever a new user signs up in Firebase Auth
// It automatically creates a "customer" document in Firestore.
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
    try {
        const userDoc = {
            id: user.uid,
            name: user.displayName || "Customer",
            email: user.email || "",
            profileImageUrl: user.photoURL || null,
            role: "customer", // enforce customer role securely
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        await admin.firestore().collection("users").doc(user.uid).set(userDoc);
        console.log(`Successfully created user doc for ${user.uid}`);
    } catch (error) {
        console.error(`Error creating user doc for ${user.uid}:`, error);
    }
});

// A callable function an admin can use to securely grant admin access to another user
exports.grantAdminRole = functions.https.onCall(async (data, context) => {
    // Check if the request is made by an authenticated user
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "Only authenticated users can call this function."
        );
    }

    // Check if the caller themselves is an admin by reading their firestore doc
    const callerDoc = await admin.firestore().collection("users").doc(context.auth.uid).get();
    if (!callerDoc.exists || callerDoc.data().role !== "admin") {
        throw new functions.https.HttpsError(
            "permission-denied",
            "Only administrators can grant admin roles."
        );
    }

    // Grant admin to the target userId provided in 'data'
    const targetUid = data.uid;
    if (!targetUid) {
        throw new functions.https.HttpsError("invalid-argument", "Missing uid.");
    }

    await admin.firestore().collection("users").doc(targetUid).update({
        role: "admin",
    });

    return { message: `Successfully granted admin role to ${targetUid}` };
});

// --- FOODS API ---

// Public: Get all foods
exports.getFoods = functions.https.onCall(async (data, context) => {
    const snapshot = await admin.firestore().collection("foods").get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
});

// Public: Get all categories
exports.getCategories = functions.https.onCall(async (data, context) => {
    const snapshot = await admin.firestore().collection("categories").get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
});

// Admin: Add food
exports.addFood = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const foodData = data.food;
    const docRef = admin.firestore().collection("foods").doc(foodData.id || `FOOD_${Date.now()}`);
    await docRef.set({ ...foodData });
    return { id: docRef.id };
});

// Admin: Update food
exports.updateFood = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const { id, updates } = data;
    await admin.firestore().collection("foods").doc(id).update(updates);
    return { success: true };
});

// Admin: Delete food
exports.deleteFood = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    await admin.firestore().collection("foods").doc(data.id).delete();
    return { success: true };
});

// --- ORDERS API ---

// Customer: Place order
exports.placeOrder = functions.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be logged in.");

    const orderData = {
        ...data.order,
        userId: context.auth.uid,
        placedAt: admin.firestore.FieldValue.serverTimestamp(),
        status: "pending"
    };

    const docRef = await admin.firestore().collection("orders").add(orderData);
    return { id: docRef.id };
});

// Customer: Get my orders
exports.getUserOrders = functions.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be logged in.");

    const snapshot = await admin.firestore()
        .collection("orders")
        .where("userId", "==", context.auth.uid)
        .orderBy("placedAt", "desc")
        .get();

    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
});

// Admin: Get all orders
exports.getAdminOrders = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const snapshot = await admin.firestore()
        .collection("orders")
        .orderBy("placedAt", "desc")
        .get();

    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
});

// Admin: Update order status
exports.updateOrderStatus = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const { id, status } = data;
    await admin.firestore().collection("orders").doc(id).update({ status });
    return { success: true };
});

// --- USERS API ---

// Admin: Get all users
exports.getUsers = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const snapshot = await admin.firestore()
        .collection("users")
        .orderBy("createdAt", "desc")
        .get();

    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
});

// Admin: Get single user details + their orders
exports.getUserDetails = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const { uid } = data;
    if (!uid) throw new functions.https.HttpsError("invalid-argument", "Missing uid.");

    const userDoc = await admin.firestore().collection("users").doc(uid).get();
    if (!userDoc.exists) {
        throw new functions.https.HttpsError("not-found", "User not found.");
    }

    const ordersSnapshot = await admin.firestore()
        .collection("orders")
        .where("userId", "==", uid)
        .orderBy("placedAt", "desc")
        .get();

    const orders = ordersSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    return {
        user: { id: userDoc.id, ...userDoc.data() },
        orders
    };
});

// Admin: Update user role
exports.updateUserRole = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const { uid, role } = data;
    if (!uid || !role) throw new functions.https.HttpsError("invalid-argument", "Missing uid or role.");
    if (!["customer", "admin"].includes(role)) {
        throw new functions.https.HttpsError("invalid-argument", "Role must be 'customer' or 'admin'.");
    }

    await admin.firestore().collection("users").doc(uid).update({ role });
    return { success: true };
});

// Admin: Delete user
exports.deleteUser = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const { uid } = data;
    if (!uid) throw new functions.https.HttpsError("invalid-argument", "Missing uid.");

    await admin.firestore().collection("users").doc(uid).delete();
    return { success: true };
});

// --- STORAGE API ---

// Authenticated: Upload image
exports.uploadImage = functions.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be logged in.");

    const { base64, path } = data;
    if (!base64 || !path) throw new functions.https.HttpsError("invalid-argument", "Missing data.");

    const buffer = Buffer.from(base64, 'base64');
    const file = bucket.file(path);

    await file.save(buffer, {
        metadata: { contentType: 'image/jpeg' }, // or detect
        public: true
    });

    // Construct a public URL (or use signed URL if preferred)
    return { url: `https://storage.googleapis.com/${bucket.name}/${path}` };
});

// Admin: Delete image
exports.deleteImage = functions.https.onCall(async (data, context) => {
    await checkAdmin(context);
    const { path } = data;
    await bucket.file(path).delete();
    return { success: true };
});

// --- UTILS ---

async function checkAdmin(context) {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Must be logged in.");
    const userDoc = await admin.firestore().collection("users").doc(context.auth.uid).get();
    if (!userDoc.exists || userDoc.data().role !== "admin") {
        throw new functions.https.HttpsError("permission-denied", "Admin ONLY.");
    }
}

// A Firestore trigger that listens for order status updates
exports.onOrderStatusChanged = functions.firestore
    .document("orders/{orderId}")
    .onUpdate(async (change, context) => {
        const newValue = change.after.data();
        const previousValue = change.before.data();

        if (newValue.status !== previousValue.status) {
            console.log(`Order ${context.params.orderId} status changed from ${previousValue.status} to ${newValue.status}`);
        }
        return null;
    });
