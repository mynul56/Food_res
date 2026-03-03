import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { functions } from "../firebase.ts";
import { httpsCallable } from "firebase/functions";
import type { FoodEntity } from "../types.ts";

export default function AddEditFood() {
    const { id } = useParams<{ id: string }>();
    const navigate = useNavigate();
    const isEditing = Boolean(id);

    const [name, setName] = useState("");
    const [price, setPrice] = useState("");
    const [category, setCategory] = useState("General");
    const [description, setDescription] = useState("");
    const [file, setFile] = useState<File | null>(null);
    const [existingImageUrl, setExistingImageUrl] = useState("");
    const [loading, setLoading] = useState(false);

    const [existingData, setExistingData] = useState<Partial<FoodEntity>>({});

    useEffect(() => {
        if (isEditing && id) {
            const fetchFood = async () => {
                try {
                    const getFoodsFn = httpsCallable(functions, 'getFoods');
                    const result = await getFoodsFn();
                    const allFoods = result.data as FoodEntity[];
                    const food = allFoods.find(f => f.id === id);

                    if (food) {
                        setName(food.name);
                        setPrice(food.price.toString());
                        setCategory(food.category);
                        setDescription(food.description);
                        setExistingImageUrl(food.imageUrl);
                        setExistingData(food);
                    }
                } catch (err) {
                    console.error("Error fetching food:", err);
                }
            };
            fetchFood();
        }
    }, [id, isEditing]);

    const fileToBase64 = (file: File): Promise<string> => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => {
                const result = reader.result as string;
                resolve(result.split(',')[1]); // remove prefix like "data:image/jpeg;base64,"
            };
            reader.onerror = error => reject(error);
        });
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!name || !price) {
            alert("Name and Price are required.");
            return;
        }

        setLoading(true);
        try {
            let imageUrl = existingImageUrl;

            if (file) {
                const base64 = await fileToBase64(file);
                const uploadImageFn = httpsCallable(functions, 'uploadImage');
                const uploadResult = await uploadImageFn({
                    base64,
                    path: `food_images/food_${Date.now()}_${file.name}`
                });
                imageUrl = (uploadResult.data as { url: string }).url;
            }

            const foodId = isEditing ? id! : `FOOD_${Date.now()}`;
            const foodData: FoodEntity = {
                id: foodId,
                name: name.trim(),
                price: parseFloat(price) || 0,
                category: category.trim() || 'General',
                description: description.trim(),
                imageUrl: imageUrl,
                rating: existingData.rating ?? 0,
                reviewCount: existingData.reviewCount ?? 0,
                isPopular: existingData.isPopular ?? false,
                calories: existingData.calories ?? 0,
                prepTimeMinutes: existingData.prepTimeMinutes ?? 15,
                isFavorite: existingData.isFavorite ?? false,
            };

            if (isEditing) {
                const updateFoodFn = httpsCallable(functions, 'updateFood');
                await updateFoodFn({ id: foodId, updates: foodData });
            } else {
                const addFoodFn = httpsCallable(functions, 'addFood');
                await addFoodFn({ food: foodData });
            }

            navigate("/menu");
        } catch (err) {
            console.error(err);
            alert("Failed to save food.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div style={{ maxWidth: '600px', margin: '0 auto' }}>
            <h1 className="page-title">{isEditing ? "Edit" : "Add"} Food Item</h1>

            <div className="card">
                <form onSubmit={handleSubmit}>

                    <div className="form-group">
                        <label>Image</label>
                        <div
                            style={{
                                width: '100%', height: '200px', backgroundColor: '#f3f4f6',
                                borderRadius: '8px', display: 'flex', alignItems: 'center', justifyContent: 'center',
                                overflow: 'hidden', border: '1px dashed var(--border-color)', marginBottom: '12px'
                            }}
                        >
                            {file ? (
                                <img src={URL.createObjectURL(file)} alt="Preview" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                            ) : existingImageUrl ? (
                                <img src={existingImageUrl} alt="Existing" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                            ) : (
                                <span style={{ color: 'var(--text-secondary)' }}>No Image Selected</span>
                            )}
                        </div>
                        <input
                            type="file"
                            accept="image/*"
                            onChange={(e) => setFile(e.target.files?.[0] || null)}
                        />
                    </div>

                    <div className="form-group">
                        <label>Food Name</label>
                        <input
                            required
                            className="form-input"
                            value={name}
                            onChange={e => setName(e.target.value)}
                            placeholder="e.g. Cheese Burger"
                        />
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
                        <div className="form-group">
                            <label>Price ($)</label>
                            <input
                                required
                                type="number"
                                step="0.01"
                                className="form-input"
                                value={price}
                                onChange={e => setPrice(e.target.value)}
                                placeholder="0.00"
                            />
                        </div>

                        <div className="form-group">
                            <label>Category</label>
                            <input
                                className="form-input"
                                value={category}
                                onChange={e => setCategory(e.target.value)}
                                placeholder="e.g. Burgers"
                            />
                        </div>
                    </div>

                    <div className="form-group">
                        <label>Description</label>
                        <textarea
                            className="form-input"
                            rows={4}
                            value={description}
                            onChange={e => setDescription(e.target.value)}
                            placeholder="Appetizing description..."
                        />
                    </div>

                    <div style={{ display: 'flex', gap: '16px', marginTop: '32px' }}>
                        <button
                            type="button"
                            onClick={() => navigate('/menu')}
                            className="btn-danger"
                            style={{ flex: 1, backgroundColor: '#f3f4f6', color: '#374151' }}
                        >
                            Cancel
                        </button>
                        <button
                            type="submit"
                            className="btn-primary"
                            style={{ flex: 2 }}
                            disabled={loading}
                        >
                            {loading ? "Saving..." : "Save Food"}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
}
