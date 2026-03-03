export interface FoodEntity {
    id: string;
    name: string;
    category: string;
    price: number;
    rating: number;
    reviewCount: number;
    imageUrl: string;
    description: string;
    isPopular: boolean;
    calories: number;
    prepTimeMinutes: number;
    isFavorite: boolean;
}

export type OrderStatus = 'pending' | 'preparing' | 'out_for_delivery' | 'delivered';

export interface CartItemEntity {
    food: FoodEntity;
    quantity: number;
}

export interface OrderEntity {
    id: string;
    userId: string;
    items: CartItemEntity[];
    total: number;
    placedAt: any; // Firestore timestamp
    status: OrderStatus;
    address?: string;
}
