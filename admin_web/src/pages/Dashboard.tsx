import { useEffect, useState } from "react";
import { functions } from "../firebase.ts";
import { httpsCallable } from "firebase/functions";
import type { OrderEntity } from "../types.ts";
import { DollarSign, ShoppingBag } from "lucide-react";

export default function Dashboard() {
    const [recentOrders, setRecentOrders] = useState<OrderEntity[]>([]);
    const [totalRevenue, setTotalRevenue] = useState(0);
    const [totalOrders, setTotalOrders] = useState(0);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchOrders = async () => {
            try {
                const getAdminOrders = httpsCallable(functions, 'getAdminOrders');
                const result = await getAdminOrders();
                const ordersData = result.data as OrderEntity[];

                setRecentOrders(ordersData.slice(0, 5));
                setTotalOrders(ordersData.length);
                setTotalRevenue(ordersData.reduce((acc: number, curr: OrderEntity) => acc + curr.total, 0));
            } catch (error) {
                console.error("Error fetching orders:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchOrders();
    }, []);

    if (loading) return <div>Loading dashboard...</div>;

    return (
        <div>
            <h1 className="page-title">Dashboard Overview</h1>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '24px', marginBottom: '32px' }}>
                <div className="card" style={{ display: 'flex', alignItems: 'center', gap: '20px' }}>
                    <div style={{ padding: '16px', backgroundColor: '#e0f2fe', color: '#0284c7', borderRadius: '50%' }}>
                        <DollarSign size={32} />
                    </div>
                    <div>
                        <div style={{ color: 'var(--text-secondary)', fontWeight: 500 }}>Total Revenue</div>
                        <div style={{ fontSize: '2rem', fontWeight: 700 }}>${totalRevenue.toFixed(2)}</div>
                    </div>
                </div>

                <div className="card" style={{ display: 'flex', alignItems: 'center', gap: '20px' }}>
                    <div style={{ padding: '16px', backgroundColor: '#fcece8', color: 'var(--primary-color)', borderRadius: '50%' }}>
                        <ShoppingBag size={32} />
                    </div>
                    <div>
                        <div style={{ color: 'var(--text-secondary)', fontWeight: 500 }}>Total Orders</div>
                        <div style={{ fontSize: '2rem', fontWeight: 700 }}>{totalOrders}</div>
                    </div>
                </div>
            </div>

            <div className="card">
                <h2 style={{ fontSize: '1.25rem', fontWeight: 600, marginBottom: '20px' }}>Recent Orders</h2>
                <div className="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Items</th>
                                <th>Total</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {recentOrders.map(order => (
                                <tr key={order.id}>
                                    <td style={{ fontWeight: 500 }}>{order.id}</td>
                                    <td>{order.items.length} items</td>
                                    <td>${order.total.toFixed(2)}</td>
                                    <td>
                                        <span className={`badge badge-${order.status}`}>
                                            {order.status.replace(/_/g, ' ')}
                                        </span>
                                    </td>
                                </tr>
                            ))}
                            {recentOrders.length === 0 && (
                                <tr>
                                    <td colSpan={4} style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>
                                        No recent orders.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
