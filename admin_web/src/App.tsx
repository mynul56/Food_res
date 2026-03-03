import { useState, useEffect } from "react";
import { Routes, Route, BrowserRouter, Navigate } from "react-router-dom";
import { onAuthStateChanged, type User } from "firebase/auth";
import { auth } from "./firebase.ts";
import Layout from "./pages/Layout.tsx";
import Dashboard from "./pages/Dashboard.tsx";
import ManageMenu from "./pages/ManageMenu.tsx";
import AddEditFood from "./pages/AddEditFood.tsx";
import ManageOrders from "./pages/ManageOrders.tsx";
import Login from "./pages/Login.tsx";

function App() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (firebaseUser) => {
      setUser(firebaseUser);
      setLoading(false);
    });
    return () => unsubscribe();
  }, []);

  if (loading) {
    return (
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        height: '100vh', fontSize: '1.1rem', color: '#6B7280'
      }}>
        Loading...
      </div>
    );
  }

  return (
    <BrowserRouter>
      <Routes>
        {user ? (
          <Route path="/" element={<Layout />}>
            <Route index element={<Dashboard />} />
            <Route path="menu" element={<ManageMenu />} />
            <Route path="add-food" element={<AddEditFood />} />
            <Route path="edit-food/:id" element={<AddEditFood />} />
            <Route path="orders" element={<ManageOrders />} />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Route>
        ) : (
          <>
            <Route path="/login" element={<Login />} />
            <Route path="*" element={<Navigate to="/login" replace />} />
          </>
        )}
      </Routes>
    </BrowserRouter>
  );
}

export default App;
