import 'package:flutter/foundation.dart';

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

class DefectTypeModel {
  final String id;
  final String name;
  final String equipmentType; // 'Carrinho' ou 'Cesto'
  final double repairCost;
  final String category; // 'Rodízios / Rodas', 'Estrutura / Solda', 'Manopla / Alças', 'Sistema Antifurto'
  final String slaTime;

  const DefectTypeModel({
    required this.id,
    required this.name,
    required this.equipmentType,
    required this.repairCost,
    required this.category,
    required this.slaTime,
  });

  String get formattedCost => 'R\$ ${repairCost.toStringAsFixed(2).replaceAll('.', ',')}';
}

class TaskItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String resolvedSubtitle;
  String timeText;
  String status; // 'critical', 'warning', 'resolved'
  final String fromLocation;
  final String toLocation;
  final String quantityText;
  final String priorityText;
  final String corridorLabel;
  final String estimatedTime;
  final String profileBannerTitle;
  final String profileDescription;

  TaskItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.resolvedSubtitle,
    required this.timeText,
    required this.status,
    required this.fromLocation,
    required this.toLocation,
    required this.quantityText,
    required this.priorityText,
    required this.corridorLabel,
    required this.estimatedTime,
    required this.profileBannerTitle,
    required this.profileDescription,
  });

  bool get isResolved => status == 'resolved';
}

class MockDB {
  // Notificador global para sincronizar telas de Tarefas e Perfil do Funcionário
  static final ValueNotifier<int> stateNotifier = ValueNotifier<int>(0);

  static int completedTasksCount = 3;

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
    {"name": "Estação 1 - Entrada", "status": "critical", "percentage": 23},
    {"name": "Estação 2 - Saída", "status": "stable", "percentage": 78},
    {"name": "Estação 3 - Hortifruti", "status": "alert", "percentage": 45},
    {"name": "Estação 4 - Padaria", "status": "stable", "percentage": 91},
  ];

  // Catálogo pré-cadastrado de Tipologia de Avarias e Custos de Reparo
  static const List<DefectTypeModel> defectCatalog = [
    // Carrinhos
    DefectTypeModel(
      id: 'def_cart_wheel',
      name: 'Roda dianteira travada ou quebrada',
      equipmentType: 'Carrinho',
      repairCost: 45.00,
      category: 'Rodízios / Rodas',
      slaTime: '2h (Oficina Interna)',
    ),
    DefectTypeModel(
      id: 'def_cart_frame',
      name: 'Grade lateral ou estrutura amassada (Solda)',
      equipmentType: 'Carrinho',
      repairCost: 85.00,
      category: 'Estrutura / Solda',
      slaTime: '4h (Serralheria)',
    ),
    DefectTypeModel(
      id: 'def_cart_handle',
      name: 'Manopla / Barra de direção solta',
      equipmentType: 'Carrinho',
      repairCost: 35.00,
      category: 'Manopla / Alças',
      slaTime: '1h (Oficina Interna)',
    ),
    DefectTypeModel(
      id: 'def_cart_lock',
      name: 'Trava eletrônica antifurto com falha',
      equipmentType: 'Carrinho',
      repairCost: 110.00,
      category: 'Sistema Antifurto',
      slaTime: '6h (Técnico IoT)',
    ),
    DefectTypeModel(
      id: 'def_cart_axle',
      name: 'Eixo traseiro desalinhado por sobrecarga',
      equipmentType: 'Carrinho',
      repairCost: 65.00,
      category: 'Rodízios / Rodas',
      slaTime: '3h (Oficina Interna)',
    ),
    // Cestos
    DefectTypeModel(
      id: 'def_basket_handle',
      name: 'Alça plástica lateral trincada',
      equipmentType: 'Cesto',
      repairCost: 18.00,
      category: 'Manopla / Alças',
      slaTime: '45min (Substituição)',
    ),
    DefectTypeModel(
      id: 'def_basket_body',
      name: 'Fundo ou grade plástica rachada',
      equipmentType: 'Cesto',
      repairCost: 25.00,
      category: 'Estrutura / Solda',
      slaTime: '1h (Triagem)',
    ),
    DefectTypeModel(
      id: 'def_basket_wheel',
      name: 'Rodinhas do cesto travadas por detritos',
      equipmentType: 'Cesto',
      repairCost: 22.00,
      category: 'Rodízios / Rodas',
      slaTime: '45min (Limpeza/Troca)',
    ),
  ];

  // Estado salvo por equipamento (ex: 'CR001', 'CS001') para persistir avarias e status
  static final Map<String, Map<String, dynamic>> equipmentRecords = {};

  // Histórico de ocorrências de manutenção da semana (usado no Dashboard e no Relatório PDF)
  static final List<Map<String, dynamic>> maintenanceLogs = [
    {
      'code': 'CR001',
      'station': 'Estação 1 - Entrada',
      'defectName': 'Roda dianteira travada ou quebrada',
      'category': 'Rodízios / Rodas',
      'cost': 45.00,
      'status': 'Em conserto',
    },
    {
      'code': 'CR007',
      'station': 'Estação 3 - Hortifruti',
      'defectName': 'Roda dianteira travada ou quebrada',
      'category': 'Rodízios / Rodas',
      'cost': 45.00,
      'status': 'Em conserto',
    },
    {
      'code': 'CR009',
      'station': 'Estação 1 - Entrada',
      'defectName': 'Grade lateral ou estrutura amassada (Solda)',
      'category': 'Estrutura / Solda',
      'cost': 85.00,
      'status': 'Em conserto',
    },
    {
      'code': 'CR015',
      'station': 'Estação 4 - Padaria',
      'defectName': 'Eixo traseiro desalinhado por sobrecarga',
      'category': 'Rodízios / Rodas',
      'cost': 65.00,
      'status': 'Em conserto',
    },
    {
      'code': 'CR016',
      'station': 'Estação 2 - Saída',
      'defectName': 'Manopla / Barra de direção solta',
      'category': 'Manopla / Alças',
      'cost': 35.00,
      'status': 'Ativo',
    },
    {
      'code': 'CS002',
      'station': 'Estação 3 - Hortifruti',
      'defectName': 'Alça plástica lateral trincada',
      'category': 'Manopla / Alças',
      'cost': 18.00,
      'status': 'Em conserto',
    },
    {
      'code': 'CR024',
      'station': 'Estação 2 - Saída',
      'defectName': 'Trava eletrônica antifurto com falha',
      'category': 'Sistema Antifurto',
      'cost': 110.00,
      'status': 'Em conserto',
    },
  ];

  static List<DefectTypeModel> getDefectsForType(String equipmentType) {
    return defectCatalog.where((d) => d.equipmentType == equipmentType).toList();
  }

  static Map<String, dynamic> getEquipmentRecord(String code, String equipmentType, String stationName) {
    if (!equipmentRecords.containsKey(code)) {
      final defaultDefect = getDefectsForType(equipmentType).first;
      equipmentRecords[code] = {
        'code': code,
        'equipmentType': equipmentType,
        'station': stationName,
        'status': 'Ativo',
        'defectId': defaultDefect.id,
        'defectName': defaultDefect.name,
        'category': defaultDefect.category,
        'repairCost': defaultDefect.repairCost,
        'slaTime': defaultDefect.slaTime,
        'notes': '',
        'hasPhoto': false,
      };
    }
    return equipmentRecords[code]!;
  }

  static void reportEquipmentDefect({
    required String code,
    required String equipmentType,
    required String stationName,
    required DefectTypeModel defect,
    required String notes,
    required bool hasPhoto,
  }) {
    final record = getEquipmentRecord(code, equipmentType, stationName);
    record['defectId'] = defect.id;
    record['defectName'] = defect.name;
    record['category'] = defect.category;
    record['repairCost'] = defect.repairCost;
    record['slaTime'] = defect.slaTime;
    record['notes'] = notes;
    record['hasPhoto'] = hasPhoto;
    record['status'] = 'Em conserto';

    final existingIdx = maintenanceLogs.indexWhere((m) => m['code'] == code);
    final logEntry = {
      'code': code,
      'station': stationName,
      'defectName': defect.name,
      'category': defect.category,
      'cost': defect.repairCost,
      'status': 'Aguardando Aprovação / Conserto',
    };
    if (existingIdx != -1) {
      maintenanceLogs[existingIdx] = logEntry;
    } else {
      maintenanceLogs.insert(0, logEntry);
    }
    stateNotifier.value++;
  }

  static void updateEquipmentStatus({
    required String code,
    required String equipmentType,
    required String stationName,
    required String newStatus,
    required DefectTypeModel defect,
  }) {
    final record = getEquipmentRecord(code, equipmentType, stationName);
    record['status'] = newStatus;
    record['defectId'] = defect.id;
    record['defectName'] = defect.name;
    record['category'] = defect.category;
    record['repairCost'] = defect.repairCost;
    record['slaTime'] = defect.slaTime;

    final existingIdx = maintenanceLogs.indexWhere((m) => m['code'] == code);
    if (existingIdx != -1) {
      maintenanceLogs[existingIdx]['status'] = newStatus;
      maintenanceLogs[existingIdx]['defectName'] = defect.name;
      maintenanceLogs[existingIdx]['category'] = defect.category;
      maintenanceLogs[existingIdx]['cost'] = defect.repairCost;
    } else if (newStatus != 'Ativo') {
      maintenanceLogs.insert(0, {
        'code': code,
        'station': stationName,
        'defectName': defect.name,
        'category': defect.category,
        'cost': defect.repairCost,
        'status': newStatus,
      });
    }
    stateNotifier.value++;
  }

  static double get totalMaintenanceCost {
    return maintenanceLogs.fold(0.0, (sum, item) => sum + (item['cost'] as double));
  }

  static String get formattedTotalMaintenanceCost {
    return 'R\$ ${totalMaintenanceCost.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  static Map<String, Map<String, dynamic>> get maintenanceBreakdownByCategory {
    final Map<String, Map<String, dynamic>> result = {
      'Rodízios / Rodas': {'count': 0, 'cost': 0.0},
      'Estrutura / Solda': {'count': 0, 'cost': 0.0},
      'Manopla / Alças': {'count': 0, 'cost': 0.0},
      'Sistema Antifurto': {'count': 0, 'cost': 0.0},
    };
    for (final item in maintenanceLogs) {
      final cat = item['category'] as String;
      final cost = item['cost'] as double;
      if (!result.containsKey(cat)) {
        result[cat] = {'count': 0, 'cost': 0.0};
      }
      result[cat]!['count'] = (result[cat]!['count'] as int) + 1;
      result[cat]!['cost'] = (result[cat]!['cost'] as double) + cost;
    }
    return result;
  }

  static final List<TaskItemModel> tasks = [
    TaskItemModel(
      id: 'task_1',
      title: 'Estação 1 - Entrada',
      subtitle: 'Carrinhos: 2/20 disponíveis',
      resolvedSubtitle: 'Carrinhos repostos — 15 unidades',
      timeText: 'Há 15 min',
      status: 'critical',
      fromLocation: 'Estação 2 - Saída',
      toLocation: 'Estação 1 - Entrada',
      quantityText: 'Quantidade Necessária: 15 Carrinhos',
      priorityText: 'Prioridade Máxima',
      corridorLabel: 'Corredor Principal',
      estimatedTime: '~4 min est.',
      profileBannerTitle: '• PRIORIDADE: ESTAÇÃO 1 - ENTRADA SEM CARRINHOS',
      profileDescription: 'Retirar 15 carrinhos da Estação 2 - Saída para suprir a Estação 1 - Entrada.',
    ),
    TaskItemModel(
      id: 'task_2',
      title: 'Estação 3 - Hortifruti',
      subtitle: 'Cestos: 0/15 disponíveis',
      resolvedSubtitle: 'Cestos repostos — 15 unidades',
      timeText: 'Há 8 min',
      status: 'critical',
      fromLocation: 'Estação 2 - Saída',
      toLocation: 'Estação 3 - Hortifruti',
      quantityText: 'Quantidade Necessária: 15 Cestos',
      priorityText: 'Prioridade Máxima',
      corridorLabel: 'Corredor Lateral',
      estimatedTime: '~3 min est.',
      profileBannerTitle: '• PRIORIDADE: ESTAÇÃO 3 - HORTIFRUTI SEM CESTOS',
      profileDescription: 'Retirar 15 cestos da Estação 2 - Saída e repor na Estação 3 - Hortifruti.',
    ),
    TaskItemModel(
      id: 'task_3',
      title: 'Estação 2 - Saída',
      subtitle: 'Carrinhos acumulados nos caixas: 20 unidades',
      resolvedSubtitle: 'Carrinhos recolhidos — 20 unidades',
      timeText: 'Há 22 min',
      status: 'warning',
      fromLocation: 'Estação 2 - Saída',
      toLocation: 'Estação 1 - Entrada',
      quantityText: 'Quantidade Necessária: 20 Carrinhos',
      priorityText: 'Prioridade Alta',
      corridorLabel: 'Acesso Caixas → Entrada',
      estimatedTime: '~5 min est.',
      profileBannerTitle: '• ATENÇÃO: RECOLHA NA ESTAÇÃO 2 - SAÍDA',
      profileDescription: 'Recolher 20 carrinhos acumulados nos caixas da Estação 2 - Saída para a Estação 1 - Entrada.',
    ),
    TaskItemModel(
      id: 'task_4',
      title: 'Estação 4 - Padaria',
      subtitle: 'Cestos repostos — 12 unidades',
      resolvedSubtitle: 'Cestos repostos — 12 unidades',
      timeText: 'Resolvido há 1h',
      status: 'resolved',
      fromLocation: 'Estação 1 - Entrada',
      toLocation: 'Estação 4 - Padaria',
      quantityText: 'Quantidade Necessária: 12 Cestos',
      priorityText: 'Prioridade Normal',
      corridorLabel: 'Corredor Padaria',
      estimatedTime: '~2 min est.',
      profileBannerTitle: '• CONCLUÍDA: ESTAÇÃO 4 - PADARIA',
      profileDescription: 'Reposição de 12 cestos na Estação 4 - Padaria.',
    ),
  ];

  static void resolveTask(String taskId) {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1 && !tasks[index].isResolved) {
      tasks[index].status = 'resolved';
      tasks[index].timeText = 'Resolvido agora';
      completedTasksCount++;
      currentUser['completed_tasks'] = completedTasksCount;

      // Atualiza também a capacidade da estação correspondente no painel, se houver
      if (taskId == 'task_1') {
        stations[0]['status'] = 'stable';
        stations[0]['percentage'] = 85;
      } else if (taskId == 'task_2') {
        stations[2]['status'] = 'stable';
        stations[2]['percentage'] = 90;
      } else if (taskId == 'task_3') {
        stations[1]['status'] = 'stable';
        stations[1]['percentage'] = 88;
      }

      stateNotifier.value++;
    }
  }

  static void createReplenishmentOrder({
    required String stationName,
    required String fromLocation,
    required int quantity,
    required String equipmentType,
    required bool isUrgent,
  }) {
    final newId = 'task_${tasks.length + 1}';
    tasks.insert(
      0,
      TaskItemModel(
        id: newId,
        title: stationName,
        subtitle: '$equipmentType fora da baia: $quantity unidades solicitadas',
        resolvedSubtitle: '$equipmentType repostos — $quantity unidades',
        timeText: 'Agora mesmo',
        status: isUrgent ? 'critical' : 'warning',
        fromLocation: fromLocation,
        toLocation: stationName,
        quantityText: 'Quantidade Necessária: $quantity $equipmentType',
        priorityText: isUrgent ? 'Prioridade Máxima (Gerência)' : 'Prioridade Alta (Gerência)',
        corridorLabel: 'Ordem Direta da Gerência',
        estimatedTime: '~4 min est.',
        profileBannerTitle: '• ORDEM DA GERÊNCIA: ${stationName.toUpperCase()}',
        profileDescription: 'Recolher e repor $quantity ${equipmentType.toLowerCase()} de $fromLocation para $stationName.',
      ),
    );
    stateNotifier.value++;
  }
}
