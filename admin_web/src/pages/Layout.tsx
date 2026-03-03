import React from "react";
import { Outlet, NavLink } from "react-router-dom";
import { LayoutDashboard, Menu as MenuIcon, ClipboardList, LogOut } from "lucide-react";
import { auth } from "../firebase.ts";

const Layout: React.FC = () => {
    const handleLogout = async () => {
        await auth.signOut();
        // onAuthStateChanged in App.tsx handles redirect to /login
    };

    return (
        <div className="app-container">
            <aside className="sidebar">
                <div className="sidebar-header">
                    Admin Portal
                </div>
                <nav className="sidebar-nav">
                    <NavLink
                        to="/"
                        className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}
                        end
                    >
                        <LayoutDashboard size={20} />
                        Dashboard
                    </NavLink>
                    <NavLink
                        to="/menu"
                        className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}
                    >
                        <MenuIcon size={20} />
                        Manage Menu
                    </NavLink>
                    <NavLink
                        to="/orders"
                        className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}
                    >
                        <ClipboardList size={20} />
                        Live Orders
                    </NavLink>
                </nav>
            </aside>

            <main className="main-content">
                <header className="header">
                    <div style={{ fontWeight: 500 }}>Welcome, Admin</div>
                    <button onClick={handleLogout} style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#ef4444' }}>
                        <LogOut size={18} />
                        Logout
                    </button>
                </header>

                <section className="content-area">
                    <Outlet />
                </section>
            </main>
        </div>
    );
};

export default Layout;
