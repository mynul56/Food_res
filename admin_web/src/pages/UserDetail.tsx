import { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { functions } from "../firebase.ts";
import { httpsCallable } from "firebase/functions";
import type { UserEntity, OrderEntity } from "../types.ts";
import { ArrowLeft, Shield, ShieldOff, Mail, Calendar, ShoppingBag, DollarSign, TrendingUp } from "lucide-react";

export default function UserDetail() {
    const { id } = useParams<{ id: string }>();
    const [user, setUser] = useState<UserEntity | null>(null);
    const [orders, setOrders] = useState<OrderEntity[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchUserDetails = async () => {
        try {
            const getUserDetailsFn = httpsCallable(functions, 'getUserDetails');
            const result = await getUserDetailsFn({ uid: id });
            const data = result.data as { user: UserEntity; orders: OrderEntity[] };
            setUser(data.user);
            setOrders(data.orders);
        } catch (err) {
            console.error("Failed to fetch user details:", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchUserDetails();
    }, [id]);

    const handleRoleChange = async () => {
        if (!user) return;
        const newRole = user.role === "admin" ? "customer" : "admin";
        const action = newRole === "admin" ? "promote to Admin" : "demote to Customer";
        if (confirm(`Are you sure you want to ${action} this user?`)) {
            try {
                const updateRoleFn = httpsCallable(functions, 'updateUserRole');
                await updateRoleFn({ uid: user.id, role: newRole });
                fetchUserDetails();
            } catch (err) {
                alert("Failed to update role");
            }
        }
    };

    const getInitials = (name: string) => {
        return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
    };

    const formatDate = (timestamp: any) => {
        if (!timestamp) return "N/A";
        try {
            if (timestamp._seconds) {
                return new Date(timestamp._seconds * 1000).toLocaleDateString('en-US', {
                    year: 'numeric', month: 'short', day: 'numeric'
                });
            }
            return new Date(timestamp).toLocaleDateString('en-US', {
                year: 'numeric', month: 'short', day: 'numeric'
            });
        } catch {
            return "N/A";
        }
    };

    const formatDateTime = (timestamp: any) => {
        if (!timestamp) return "N/A";
        try {
            if (timestamp._seconds) {
                return new Date(timestamp._seconds * 1000).toLocaleString('en-US', {
                    year: 'numeric', month: 'short', day: 'numeric',
                    hour: '2-digit', minute: '2-digit'
                });
            }
            return new Date(timestamp).toLocaleString('en-US', {
                year: 'numeric', month: 'short', day: 'numeric',
                hour: '2-digit', minute: '2-digit'
            });
        } catch {
            return "N/A";
        }
    };

    if (loading) return <div>Loading user details...</div>;
    if (!user) return <div>User not found.</div>;

    const totalSpent = orders.reduce((acc, order) => acc + (order.total || 0), 0);
    const avgOrderValue = orders.length > 0 ? totalSpent / orders.length : 0;

    return (
        <div>
            {/* Back button */}
            <Link to="/users" style={{ display: 'inline-flex', alignItems: 'center', gap: '6px', color: 'var(--text-secondary)', marginBottom: '20px', fontSize: '0.9rem', fontWeight: 500, transition: 'color 0.2s' }}>
                <ArrowLeft size={18} /> Back to Users
            </Link>

            <div style={{ display: 'grid', gridTemplateColumns: '340px 1fr', gap: '24px', alignItems: 'start' }}>
                {/* Profile Card */}
                <div className="card user-profile-card">
                    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center' }}>
                        {user.profileImageUrl ? (
                            <img
                                src={user.profileImageUrl}
                                alt={user.name}
                                className="profile-avatar-lg"
                            />
                        ) : (
                            <div className="profile-avatar-lg profile-avatar-fallback">
                                {getInitials(user.name)}
                            </div>
                        )}
                        <h2 style={{ fontSize: '1.35rem', fontWeight: 700, marginTop: '16px', marginBottom: '4px' }}>
                            {user.name}
                        </h2>
                        <span className={`badge badge-role-${user.role}`} style={{ fontSize: '0.8rem', padding: '5px 14px' }}>
                            {user.role}
                        </span>
                    </div>

                    <div style={{ marginTop: '24px', display: 'flex', flexDirection: 'column', gap: '14px' }}>
                        <div className="profile-info-row">
                            <Mail size={16} style={{ color: 'var(--text-secondary)' }} />
                            <span style={{ color: 'var(--text-secondary)', fontSize: '0.9rem' }}>{user.email}</span>
                        </div>
                        <div className="profile-info-row">
                            <Calendar size={16} style={{ color: 'var(--text-secondary)' }} />
                            <span style={{ color: 'var(--text-secondary)', fontSize: '0.9rem' }}>Joined {formatDate(user.createdAt)}</span>
                        </div>
                    </div>

                    <div style={{ marginTop: '24px', borderTop: '1px solid var(--border-color)', paddingTop: '20px' }}>
                        <button
                            onClick={handleRoleChange}
                            className={user.role === 'admin' ? 'btn-outline-danger' : 'btn-outline-success'}
                            style={{ width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px', padding: '10px 16px', borderRadius: '8px', fontWeight: 600, fontSize: '0.9rem' }}
                        >
                            {user.role === 'admin' ? (
                                <><ShieldOff size={16} /> Demote to Customer</>
                            ) : (
                                <><Shield size={16} /> Promote to Admin</>
                            )}
                        </button>
                    </div>
                </div>

                {/* Right side — Stats + Orders */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>
                    {/* User Stats */}
                    <div className="stat-grid">
                        <div className="stat-card">
                            <div className="stat-icon" style={{ backgroundColor: '#e0f2fe', color: '#0284c7' }}>
                                <ShoppingBag size={22} />
                            </div>
                            <div>
                                <div className="stat-label">Total Orders</div>
                                <div className="stat-value">{orders.length}</div>
                            </div>
                        </div>
                        <div className="stat-card">
                            <div className="stat-icon" style={{ backgroundColor: '#d1fae5', color: '#059669' }}>
                                <DollarSign size={22} />
                            </div>
                            <div>
                                <div className="stat-label">Total Spent</div>
                                <div className="stat-value">${totalSpent.toFixed(2)}</div>
                            </div>
                        </div>
                        <div className="stat-card">
                            <div className="stat-icon" style={{ backgroundColor: '#fef3c7', color: '#d97706' }}>
                                <TrendingUp size={22} />
                            </div>
                            <div>
                                <div className="stat-label">Avg. Order</div>
                                <div className="stat-value">${avgOrderValue.toFixed(2)}</div>
                            </div>
                        </div>
                    </div>

                    {/* Order History */}
                    <div className="card">
                        <h2 style={{ fontSize: '1.15rem', fontWeight: 600, marginBottom: '20px' }}>Order History</h2>
                        {orders.length === 0 ? (
                            <div style={{ textAlign: 'center', padding: '40px', color: 'var(--text-secondary)' }}>
                                This user hasn't placed any orders yet.
                            </div>
                        ) : (
                            <div className="table-container" style={{ boxShadow: 'none' }}>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Order ID</th>
                                            <th>Items</th>
                                            <th>Total</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {orders.map(order => (
                                            <tr key={order.id}>
                                                <td style={{ fontWeight: 500, fontSize: '0.85rem' }}>
                                                    #{order.id.slice(0, 8)}...
                                                </td>
                                                <td>{order.items?.length || 0} items</td>
                                                <td style={{ fontWeight: 600 }}>${(order.total || 0).toFixed(2)}</td>
                                                <td>
                                                    <span className={`badge badge-${order.status || 'pending'}`}>
                                                        {(order.status || 'pending').replace(/_/g, ' ')}
                                                    </span>
                                                </td>
                                                <td style={{ color: 'var(--text-secondary)', fontSize: '0.85rem' }}>
                                                    {formatDateTime(order.placedAt)}
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
}
