// Estrutura do Banco de Dados (Comentada para futura implementação)

/*
=========================================
🔥 ESTRUTURA DO BANCO DE DADOS (Pensada para Firebase Firestore ou Supabase)
=========================================

1. Coleção/Tabela: users
   - id (String, PK)
   - name (String) - Ex: "Róger Mendes Azevedo"
   - email (String) - Ex: "lagoinha@gmail.com"
   - password (String, Hash)
   - role (String) - "manager" ou "employee"
   - unit_id (String, FK) - Referência à loja
   - position (String) - Ex: "Repositor" (Apenas para employee)
   - completed_tasks (int) - Para estatísticas do perfil
   - active_time_minutes (int) - Tempo ativo no turno

2. Coleção/Tabela: units (Filiais/Lojas)
   - id (String, PK)
   - name (String) - Ex: "Supermercado Syner - Pinheiros"
   - address (String) - Ex: "Av. das Nações Unidas, 12400"
   - operating_hours (String) - Ex: "07:00 às 22:00"

3. Coleção/Tabela: stations (Estações de coleta/retirada)
   - id (String, PK)
   - unit_id (String, FK)
   - name (String) - Ex: "Estação 1 - Entrada Principal"
   - max_capacity (int) - Ex: 300
   - current_count (int) - Ex: 69
   - status (String) - "critical", "stable", "alert"

4. Coleção/Tabela: equipment (Carrinhos e Cestos)
   - id (String, PK)
   - station_id (String, FK)
   - type (String) - "cart" (carrinho) ou "basket" (cesto)
   - equipment_code (String) - Ex: "CR001"
   - status (String) - "active", "inactive", "damaged"
   - defect_description (String) - Ex: "Roda dianteira da frente quebrada"
   - created_at (DateTime)

5. Coleção/Tabela: tasks (Tarefas)
   - id (String, PK)
   - assignee_id (String, FK, nullable) - ID do funcionário (nulo se aberta)
   - title (String) - Ex: "Recolha Urgente de Carrinhos"
   - description (String) - Ex: "Retirar 15 unidades do Depósito Sul para suprir a entrada principal"
   - from_location (String) - Ex: "Saída B"
   - to_station_id (String, FK) - Ex: "Entrada Principal"
   - quantity_needed (int) - Ex: 15
   - priority (String) - "maximum", "normal"
   - status (String) - "pending", "accepted", "resolved"
   - created_at (DateTime)

=========================================
*/

class MockDB {
  // Simulação de dados para a interface funcionar
  static final Map<String, dynamic> currentUser = {
    "id": "8849",
    "name": "João Silva",
    "email": "Silvajo@gmail.com",
    "role": "employee",
    "position": "Repositor",
    "completed_tasks": 3,
    "active_time": "4h 30m"
  };

  static final List<Map<String, dynamic>> stations = [
    {"name": "Entrada Principal", "status": "critical", "percentage": 23},
    {"name": "Saída", "status": "stable", "percentage": 78},
    {"name": "Depósito Cestos", "status": "alert", "percentage": 45},
    {"name": "Estacionamento", "status": "stable", "percentage": 91},
    {"name": "Hortifruti", "status": "alert", "percentage": 60},
  ];
}
