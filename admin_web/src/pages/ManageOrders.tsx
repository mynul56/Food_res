import { useEffect, useState } from "react";
import { functions } from "../firebase.ts";
import { httpsCallable } from "firebase/functions";
import type { OrderEntity, OrderStatus } from "../types.ts";

export default function ManageOrders() {
    const [orders, setOrders] = useState<OrderEntity[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchOrders = async () => {
        try {
            const getAdminOrders = httpsCallable(functions, 'getAdminOrders');
            const result = await getAdminOrders();
            setOrders(result.data as OrderEntity[]);
        } catch (err) {
            console.error("Failed to fetch orders:", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchOrders();
    }, []);

    const updateStatus = async (orderId: string, status: OrderStatus) => {
        try {
            const updateStatusFn = httpsCallable(functions, 'updateOrderStatus');
            await updateStatusFn({ id: orderId, status });
            fetchOrders(); // refresh list
        } catch (err) {
            alert("Failed to update status");
        }
    };

    if (loading) return <div>Loading live orders...</div>;

    return (
        <div>
            <h1 className="page-title">Live Orders</h1>

            {orders.length === 0 ? (
                <div style={{ textAlign: 'center', padding: '40px', color: 'var(--text-secondary)' }}>
                    No active orders at the moment.
                </div>
            ) : (
                <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                    {orders.map(order => (
                        <div key={order.id} className="card" style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>

                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                                <div>
                                    <h3 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 600 }}>Order #{order.id}</h3>
                                    <div style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', marginTop: '4px' }}>
                                        {order.items.length} items • ${order.total.toFixed(2)}
                                    </div>
                                </div>
                                <div>
                                    <span className={`badge badge-${order.status || 'pending'}`}>
                                        {(order.status || 'pending').replace(/_/g, ' ')}
                                    </span>
                                </div>
                            </div>

                            <div style={{ padding: '16px', backgroundColor: '#f9fafb', borderRadius: '8px' }}>
                                <h4 style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', textTransform: 'uppercase', marginBottom: '8px' }}>Delivery Details</h4>
                                <div style={{ fontWeight: 500 }}>{order.address || "No address provided"}</div>
                            </div>

                            <div>
                                <h4 style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', textTransform: 'uppercase', marginBottom: '8px' }}>Update Status</h4>
                                <div style={{ display: 'flex', gap: '12px', flexWrap: 'wrap' }}>
                                    {['pending', 'preparing', 'out_for_delivery', 'delivered'].map((status) => {
                                        const isActive = order.status === status;
                                        return (
                                            <button
                                                key={status}
                                                onClick={() => updateStatus(order.id, status as OrderStatus)}
                                                style={{
                                                    padding: '8px 16px', borderRadius: '9999px', fontSize: '0.875rem', fontWeight: 500,
                                                    backgroundColor: isActive ? 'var(--primary-color)' : '#f3f4f6',
                                                    color: isActive ? '#fff' : '#374151',
                                                    border: isActive ? 'none' : '1px solid #d1d5db',
                                                    transition: 'all 0.2s', cursor: isActive ? 'default' : 'pointer'
                                                }}
                                                disabled={isActive || (status === 'pending' && !order.status)}
                                            >
                                                {status.replace(/_/g, ' ')}
                                            </button>
                                        );
                                    })}
                                </div>
                            </div>

                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
