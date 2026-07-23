/**
 * @file database.ts
 * @version 0.1.0
 * @description Tipe database sementara yang mengikuti migration awal Supabase.
 */

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

type TableDefinition<Row, Insert, Update> = {
  Row: Row;
  Insert: Insert;
  Update: Update;
  Relationships: [];
};

export interface Database {
  public: {
    Tables: {
      roles: TableDefinition<
        {
          id: string;
          code: "owner" | "cashier";
          name: string;
          permissions: Json;
          created_at: string;
        },
        {
          id?: string;
          code: "owner" | "cashier";
          name: string;
          permissions?: Json;
          created_at?: string;
        },
        {
          code?: "owner" | "cashier";
          name?: string;
          permissions?: Json;
        }
      >;
      users: TableDefinition<
        {
          id: string;
          name: string;
          role_id: string;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        },
        {
          id: string;
          name: string;
          role_id: string;
          is_active?: boolean;
          created_at?: string;
          updated_at?: string;
        },
        {
          name?: string;
          role_id?: string;
          is_active?: boolean;
          updated_at?: string;
        }
      >;
      products: TableDefinition<
        {
          id: string;
          name: string;
          category: "Dessert" | "Minuman" | "Bundling";
          selling_price: number;
          standard_cost: number;
          image_url: string | null;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        },
        {
          id?: string;
          name: string;
          category: "Dessert" | "Minuman" | "Bundling";
          selling_price: number;
          standard_cost: number;
          image_url?: string | null;
          is_active?: boolean;
          created_at?: string;
          updated_at?: string;
        },
        {
          name?: string;
          category?: "Dessert" | "Minuman" | "Bundling";
          selling_price?: number;
          standard_cost?: number;
          image_url?: string | null;
          is_active?: boolean;
          updated_at?: string;
        }
      >;
      transactions: TableDefinition<
        {
          id: string;
          transaction_number: string;
          business_date: string;
          customer_name: string | null;
          customer_phone: string | null;
          payment_status: "Sudah" | "Belum";
          total_amount: number;
          total_cost: number;
          notes: string | null;
          idempotency_key: string;
          is_void: boolean;
          void_reason: string | null;
          voided_at: string | null;
          voided_by: string | null;
          paid_at: string | null;
          paid_by: string | null;
          created_by: string;
          created_at: string;
        },
        never,
        never
      >;
      transaction_items: TableDefinition<
        {
          id: string;
          transaction_id: string;
          product_id: string;
          product_name_snapshot: string;
          unit_price_snapshot: number;
          unit_cost_snapshot: number;
          quantity: number;
          subtotal: number;
          cost_total: number;
          created_at: string;
        },
        never,
        never
      >;
      audit_logs: TableDefinition<
        {
          id: string;
          entity_type: "transaction";
          entity_id: string;
          action: "create" | "mark_paid" | "mark_unpaid" | "void";
          old_values: Json | null;
          new_values: Json | null;
          actor_id: string;
          created_at: string;
        },
        never,
        never
      >;
    };
    Views: Record<string, never>;
    Functions: {
      create_transaction: {
        Args: {
          p_idempotency_key: string;
          p_payment_status: "Sudah" | "Belum";
          p_items: Json;
          p_customer_name?: string | null;
          p_customer_phone?: string | null;
          p_notes?: string | null;
        };
        Returns: Database["public"]["Tables"]["transactions"]["Row"];
      };
      set_transaction_payment_status: {
        Args: {
          p_transaction_id: string;
          p_payment_status: "Sudah" | "Belum";
          p_customer_name?: string | null;
        };
        Returns: Database["public"]["Tables"]["transactions"]["Row"];
      };
      void_transaction: {
        Args: { p_transaction_id: string; p_reason: string };
        Returns: Database["public"]["Tables"]["transactions"]["Row"];
      };
    };
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
}
