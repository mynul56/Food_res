import { useState, useEffect } from "react";
import { functions } from "../firebase.ts";
import { httpsCallable } from "firebase/functions";
import type { FoodEntity } from "../types.ts";
import { Plus, Edit, Trash2 } from "lucide-react";
import { Link } from "react-router-dom";

export default function ManageMenu() {
    const [foods, setFoods] = useState<FoodEntity[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchFoods = async () => {
        try {
            const getFoods = httpsCallable(functions, 'getFoods');
            const result = await getFoods();
            setFoods(result.data as FoodEntity[]);
        } catch (err) {
            console.error("Failed to fetch foods:", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchFoods();
    }, []);

    const handleDelete = async (id: string, name: string) => {
        if (confirm(`Are you sure you want to delete "${name}"?`)) {
            try {
                const deleteFoodFn = httpsCallable(functions, 'deleteFood');
                await deleteFoodFn({ id });
                fetchFoods(); // list is not live anymore, so re-fetch
            } catch (err) {
                alert("Failed to delete food");
            }
        }
    };

    if (loading) return <div>Loading menu...</div>;

    return (
        <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                <h1 className="page-title" style={{ marginBottom: 0 }}>Manage Menu</h1>
                <Link to="/add-food" className="btn-primary" style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                    <Plus size={18} /> Add Food
                </Link>
            </div>

            <div className="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th style={{ textAlign: 'right' }}>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foods.map(food => (
                            <tr key={food.id}>
                                <td>
                                    <img
                                        src={food.imageUrl || "https://placehold.co/50x50"}
                                        alt={food.name}
                                        style={{ width: '50px', height: '50px', objectFit: 'cover', borderRadius: '8px' }}
                                    />
                                </td>
                                <td style={{ fontWeight: 500 }}>{food.name}</td>
                                <td>{food.category}</td>
                                <td>${food.price.toFixed(2)}</td>
                                <td style={{ textAlign: 'right' }}>
                                    <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px' }}>
                                        <Link to={`/edit-food/${food.id}`} style={{ color: '#0284c7' }}>
                                            <Edit size={18} />
                                        </Link>
                                        <button onClick={() => handleDelete(food.id, food.name)} style={{ color: '#ef4444' }}>
                                            <Trash2 size={18} />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))}
                        {foods.length === 0 && (
                            <tr>
                                <td colSpan={5} style={{ textAlign: 'center', color: 'var(--text-secondary)', padding: '40px' }}>
                                    No food items found. Start by adding one!
                                </td>
                            </tr>
                        )}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
