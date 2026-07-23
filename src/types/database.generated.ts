/**
 * @file database.generated.ts
 * @version 0.1.0
 * @description Tipe database yang dihasilkan dari schema Supabase lokal tervalidasi.
 */

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never;
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      graphql: {
        Args: {
          extensions?: Json;
          operationName?: string;
          query?: string;
          variables?: Json;
        };
        Returns: Json;
      };
    };
    Enums: {
      [_ in never]: never;
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
  public: {
    Tables: {
      audit_logs: {
        Row: {
          action: string;
          actor_id: string;
          created_at: string;
          entity_id: string;
          entity_type: string;
          id: string;
          new_values: Json | null;
          old_values: Json | null;
        };
        Insert: {
          action: string;
          actor_id: string;
          created_at?: string;
          entity_id: string;
          entity_type: string;
          id?: string;
          new_values?: Json | null;
          old_values?: Json | null;
        };
        Update: {
          action?: string;
          actor_id?: string;
          created_at?: string;
          entity_id?: string;
          entity_type?: string;
          id?: string;
          new_values?: Json | null;
          old_values?: Json | null;
        };
        Relationships: [
          {
            foreignKeyName: "audit_logs_actor_id_fkey";
            columns: ["actor_id"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "audit_logs_entity_id_fkey";
            columns: ["entity_id"];
            isOneToOne: false;
            referencedRelation: "transactions";
            referencedColumns: ["id"];
          },
        ];
      };
      products: {
        Row: {
          category: string;
          created_at: string;
          id: string;
          image_url: string | null;
          is_active: boolean;
          name: string;
          selling_price: number;
          standard_cost: number;
          updated_at: string;
        };
        Insert: {
          category: string;
          created_at?: string;
          id?: string;
          image_url?: string | null;
          is_active?: boolean;
          name: string;
          selling_price: number;
          standard_cost: number;
          updated_at?: string;
        };
        Update: {
          category?: string;
          created_at?: string;
          id?: string;
          image_url?: string | null;
          is_active?: boolean;
          name?: string;
          selling_price?: number;
          standard_cost?: number;
          updated_at?: string;
        };
        Relationships: [];
      };
      roles: {
        Row: {
          code: string;
          created_at: string;
          id: string;
          name: string;
          permissions: Json;
        };
        Insert: {
          code: string;
          created_at?: string;
          id?: string;
          name: string;
          permissions?: Json;
        };
        Update: {
          code?: string;
          created_at?: string;
          id?: string;
          name?: string;
          permissions?: Json;
        };
        Relationships: [];
      };
      transaction_items: {
        Row: {
          cost_total: number | null;
          created_at: string;
          id: string;
          product_id: string;
          product_name_snapshot: string;
          quantity: number;
          subtotal: number | null;
          transaction_id: string;
          unit_cost_snapshot: number;
          unit_price_snapshot: number;
        };
        Insert: {
          cost_total?: number | null;
          created_at?: string;
          id?: string;
          product_id: string;
          product_name_snapshot: string;
          quantity: number;
          subtotal?: number | null;
          transaction_id: string;
          unit_cost_snapshot: number;
          unit_price_snapshot: number;
        };
        Update: {
          cost_total?: number | null;
          created_at?: string;
          id?: string;
          product_id?: string;
          product_name_snapshot?: string;
          quantity?: number;
          subtotal?: number | null;
          transaction_id?: string;
          unit_cost_snapshot?: number;
          unit_price_snapshot?: number;
        };
        Relationships: [
          {
            foreignKeyName: "transaction_items_product_id_fkey";
            columns: ["product_id"];
            isOneToOne: false;
            referencedRelation: "products";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "transaction_items_transaction_id_fkey";
            columns: ["transaction_id"];
            isOneToOne: false;
            referencedRelation: "transactions";
            referencedColumns: ["id"];
          },
        ];
      };
      transactions: {
        Row: {
          business_date: string;
          created_at: string;
          created_by: string;
          customer_name: string | null;
          customer_phone: string | null;
          id: string;
          idempotency_key: string;
          is_void: boolean;
          notes: string | null;
          paid_at: string | null;
          paid_by: string | null;
          payment_status: string;
          total_amount: number;
          total_cost: number;
          transaction_number: string;
          void_reason: string | null;
          voided_at: string | null;
          voided_by: string | null;
        };
        Insert: {
          business_date?: string;
          created_at?: string;
          created_by: string;
          customer_name?: string | null;
          customer_phone?: string | null;
          id?: string;
          idempotency_key: string;
          is_void?: boolean;
          notes?: string | null;
          paid_at?: string | null;
          paid_by?: string | null;
          payment_status: string;
          total_amount: number;
          total_cost: number;
          transaction_number: string;
          void_reason?: string | null;
          voided_at?: string | null;
          voided_by?: string | null;
        };
        Update: {
          business_date?: string;
          created_at?: string;
          created_by?: string;
          customer_name?: string | null;
          customer_phone?: string | null;
          id?: string;
          idempotency_key?: string;
          is_void?: boolean;
          notes?: string | null;
          paid_at?: string | null;
          paid_by?: string | null;
          payment_status?: string;
          total_amount?: number;
          total_cost?: number;
          transaction_number?: string;
          void_reason?: string | null;
          voided_at?: string | null;
          voided_by?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "transactions_created_by_fkey";
            columns: ["created_by"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "transactions_paid_by_fkey";
            columns: ["paid_by"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "transactions_voided_by_fkey";
            columns: ["voided_by"];
            isOneToOne: false;
            referencedRelation: "users";
            referencedColumns: ["id"];
          },
        ];
      };
      users: {
        Row: {
          created_at: string;
          id: string;
          is_active: boolean;
          name: string;
          role_id: string;
          updated_at: string;
        };
        Insert: {
          created_at?: string;
          id: string;
          is_active?: boolean;
          name: string;
          role_id: string;
          updated_at?: string;
        };
        Update: {
          created_at?: string;
          id?: string;
          is_active?: boolean;
          name?: string;
          role_id?: string;
          updated_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: "users_role_id_fkey";
            columns: ["role_id"];
            isOneToOne: false;
            referencedRelation: "roles";
            referencedColumns: ["id"];
          },
        ];
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      create_transaction: {
        Args: {
          p_customer_name?: string;
          p_customer_phone?: string;
          p_idempotency_key: string;
          p_items: Json;
          p_notes?: string;
          p_payment_status: string;
        };
        Returns: {
          business_date: string;
          created_at: string;
          created_by: string;
          customer_name: string | null;
          customer_phone: string | null;
          id: string;
          idempotency_key: string;
          is_void: boolean;
          notes: string | null;
          paid_at: string | null;
          paid_by: string | null;
          payment_status: string;
          total_amount: number;
          total_cost: number;
          transaction_number: string;
          void_reason: string | null;
          voided_at: string | null;
          voided_by: string | null;
        };
        SetofOptions: {
          from: "*";
          to: "transactions";
          isOneToOne: true;
          isSetofReturn: false;
        };
      };
      create_transaction_internal: {
        Args: {
          p_customer_name?: string;
          p_customer_phone?: string;
          p_idempotency_key: string;
          p_items: Json;
          p_notes?: string;
          p_payment_status: string;
        };
        Returns: {
          business_date: string;
          created_at: string;
          created_by: string;
          customer_name: string | null;
          customer_phone: string | null;
          id: string;
          idempotency_key: string;
          is_void: boolean;
          notes: string | null;
          paid_at: string | null;
          paid_by: string | null;
          payment_status: string;
          total_amount: number;
          total_cost: number;
          transaction_number: string;
          void_reason: string | null;
          voided_at: string | null;
          voided_by: string | null;
        };
        SetofOptions: {
          from: "*";
          to: "transactions";
          isOneToOne: true;
          isSetofReturn: false;
        };
      };
      current_user_is_active: { Args: never; Returns: boolean };
      current_user_is_owner: { Args: never; Returns: boolean };
      current_user_role: { Args: never; Returns: string };
      set_transaction_payment_status: {
        Args: {
          p_customer_name?: string;
          p_payment_status: string;
          p_transaction_id: string;
        };
        Returns: {
          business_date: string;
          created_at: string;
          created_by: string;
          customer_name: string | null;
          customer_phone: string | null;
          id: string;
          idempotency_key: string;
          is_void: boolean;
          notes: string | null;
          paid_at: string | null;
          paid_by: string | null;
          payment_status: string;
          total_amount: number;
          total_cost: number;
          transaction_number: string;
          void_reason: string | null;
          voided_at: string | null;
          voided_by: string | null;
        };
        SetofOptions: {
          from: "*";
          to: "transactions";
          isOneToOne: true;
          isSetofReturn: false;
        };
      };
      void_transaction: {
        Args: { p_reason: string; p_transaction_id: string };
        Returns: {
          business_date: string;
          created_at: string;
          created_by: string;
          customer_name: string | null;
          customer_phone: string | null;
          id: string;
          idempotency_key: string;
          is_void: boolean;
          notes: string | null;
          paid_at: string | null;
          paid_by: string | null;
          payment_status: string;
          total_amount: number;
          total_cost: number;
          transaction_number: string;
          void_reason: string | null;
          voided_at: string | null;
          voided_by: string | null;
        };
        SetofOptions: {
          from: "*";
          to: "transactions";
          isOneToOne: true;
          isSetofReturn: false;
        };
      };
    };
    Enums: {
      [_ in never]: never;
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
};

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">;

type DefaultSchema = DatabaseWithoutInternals[Extract<
  keyof Database,
  "public"
>];

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R;
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R;
      }
      ? R
      : never
    : never;

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    keyof DefaultSchema["Tables"] | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I;
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I;
      }
      ? I
      : never
    : never;

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    keyof DefaultSchema["Tables"] | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U;
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U;
      }
      ? U
      : never
    : never;

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    keyof DefaultSchema["Enums"] | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never;

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never;

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const;
