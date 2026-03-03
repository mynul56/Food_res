import { useState, useEffect } from "react";
import { functions } from "../firebase.ts";
import { httpsCallable } from "firebase/functions";
import type { UserEntity } from "../types.ts";
import { Search, Eye, Shield, ShieldOff, Trash2, Users, UserCog, UserPlus } from "lucide-react";
import { Link } from "react-router-dom";

type RoleFilter = "all" | "customer" | "admin";

export default function ManageUsers() {
    const [users, setUsers] = useState<UserEntity[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchQuery, setSearchQuery] = useState("");
    const [roleFilter, setRoleFilter] = useState<RoleFilter>("all");

    const fetchUsers = async () => {
        try {
            const getUsersFn = httpsCallable(functions, 'getUsers');
            const result = await getUsersFn();
            setUsers(result.data as UserEntity[]);
        } catch (err) {
            console.error("Failed to fetch users:", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchUsers();
    }, []);

    const handleRoleChange = async (uid: string, currentRole: string) => {
        const newRole = currentRole === "admin" ? "customer" : "admin";
        const action = newRole === "admin" ? "promote to Admin" : "demote to Customer";
        if (confirm(`Are you sure you want to ${action} this user?`)) {
            try {
                const updateRoleFn = httpsCallable(functions, 'updateUserRole');
                await updateRoleFn({ uid, role: newRole });
                fetchUsers();
            } catch (err) {
                alert("Failed to update role");
            }
        }
    };

    const handleDelete = async (uid: string, name: string) => {
        if (confirm(`Are you sure you want to delete "${name}"? This cannot be undone.`)) {
            try {
                const deleteUserFn = httpsCallable(functions, 'deleteUser');
                await deleteUserFn({ uid });
                fetchUsers();
            } catch (err) {
                alert("Failed to delete user");
            }
        }
    };

    const filteredUsers = users.filter(user => {
        const matchesSearch =
            user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
            user.email.toLowerCase().includes(searchQuery.toLowerCase());
        const matchesRole = roleFilter === "all" || user.role === roleFilter;
        return matchesSearch && matchesRole;
    });

    const totalAdmins = users.filter(u => u.role === "admin").length;
    const totalCustomers = users.filter(u => u.role === "customer").length;

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

    if (loading) return <div>Loading users...</div>;

    return (
        <div>
            <h1 className="page-title">Manage Users</h1>

            {/* Stats */}
            <div className="stat-grid" style={{ marginBottom: '28px' }}>
                <div className="stat-card">
                    <div className="stat-icon" style={{ backgroundColor: '#ede9fe', color: '#7c3aed' }}>
                        <Users size={22} />
                    </div>
                    <div>
                        <div className="stat-label">Total Users</div>
                        <div className="stat-value">{users.length}</div>
                    </div>
                </div>
                <div className="stat-card">
                    <div className="stat-icon" style={{ backgroundColor: '#fef3c7', color: '#d97706' }}>
                        <UserCog size={22} />
                    </div>
                    <div>
                        <div className="stat-label">Admins</div>
                        <div className="stat-value">{totalAdmins}</div>
                    </div>
                </div>
                <div className="stat-card">
                    <div className="stat-icon" style={{ backgroundColor: '#d1fae5', color: '#059669' }}>
                        <UserPlus size={22} />
                    </div>
                    <div>
                        <div className="stat-label">Customers</div>
                        <div className="stat-value">{totalCustomers}</div>
                    </div>
                </div>
            </div>

            {/* Filters */}
            <div className="card" style={{ marginBottom: '24px' }}>
                <div style={{ display: 'flex', gap: '16px', alignItems: 'center', flexWrap: 'wrap' }}>
                    <div className="search-wrapper">
                        <Search size={18} className="search-icon" />
                        <input
                            type="text"
                            className="search-input"
                            placeholder="Search by name or email..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                        />
                    </div>
                    <div className="filter-tabs">
                        {(["all", "customer", "admin"] as RoleFilter[]).map(filter => (
                            <button
                                key={filter}
                                className={`filter-tab ${roleFilter === filter ? "active" : ""}`}
                                onClick={() => setRoleFilter(filter)}
                            >
                                {filter === "all" ? "All" : filter.charAt(0).toUpperCase() + filter.slice(1)}
                                <span className="filter-count">
                                    {filter === "all" ? users.length : filter === "admin" ? totalAdmins : totalCustomers}
                                </span>
                            </button>
                        ))}
                    </div>
                </div>
            </div>

            {/* Users Table */}
            <div className="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Joined</th>
                            <th style={{ textAlign: 'right' }}>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredUsers.map(user => (
                            <tr key={user.id}>
                                <td>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                                        {user.profileImageUrl ? (
                                            <img
                                                src={user.profileImageUrl}
                                                alt={user.name}
                                                className="user-avatar"
                                            />
                                        ) : (
                                            <div className="user-avatar user-avatar-fallback">
                                                {getInitials(user.name)}
                                            </div>
                                        )}
                                        <span style={{ fontWeight: 500 }}>{user.name}</span>
                                    </div>
                                </td>
                                <td style={{ color: 'var(--text-secondary)' }}>{user.email}</td>
                                <td>
                                    <span className={`badge badge-role-${user.role}`}>
                                        {user.role}
                                    </span>
                                </td>
                                <td style={{ color: 'var(--text-secondary)', fontSize: '0.875rem' }}>
                                    {formatDate(user.createdAt)}
                                </td>
                                <td style={{ textAlign: 'right' }}>
                                    <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '8px' }}>
                                        <Link
                                            to={`/users/${user.id}`}
                                            className="action-btn action-btn-view"
                                            title="View Details"
                                        >
                                            <Eye size={16} />
                                        </Link>
                                        <button
                                            className={`action-btn ${user.role === 'admin' ? 'action-btn-demote' : 'action-btn-promote'}`}
                                            onClick={() => handleRoleChange(user.id, user.role)}
                                            title={user.role === 'admin' ? 'Demote to Customer' : 'Promote to Admin'}
                                        >
                                            {user.role === 'admin' ? <ShieldOff size={16} /> : <Shield size={16} />}
                                        </button>
                                        <button
                                            className="action-btn action-btn-delete"
                                            onClick={() => handleDelete(user.id, user.name)}
                                            title="Delete User"
                                        >
                                            <Trash2 size={16} />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))}
                        {filteredUsers.length === 0 && (
                            <tr>
                                <td colSpan={5} style={{ textAlign: 'center', color: 'var(--text-secondary)', padding: '40px' }}>
                                    {searchQuery || roleFilter !== "all"
                                        ? "No users match your filters."
                                        : "No users found."
                                    }
                                </td>
                            </tr>
                        )}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
