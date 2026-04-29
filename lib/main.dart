import 'package:flutter/material.dart';

void main() {
  runApp(const GastosHormigaApp());
}

class GastosHormigaApp extends StatelessWidget {
  const GastosHormigaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gastos Hormiga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        primaryColor: const Color(0xFF6A93BE),
      ),
      home: const HomeScreen(),
    );
  }
}

class Gasto {
  final double monto;
  final String categoria;
  final String nota;

  Gasto({
    required this.monto,
    required this.categoria,
    required this.nota,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Gasto> gastos = [];

  final TextEditingController montoController = TextEditingController();
  final TextEditingController notaController = TextEditingController();

  String categoriaSeleccionada = 'Café';

  final List<String> categorias = [
    'Café',
    'Comida',
    'Transporte',
    'Compras',
    'Otros',
  ];

  String obtenerMesActual() {
    final meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    final ahora = DateTime.now();
    return '${meses[ahora.month - 1]} ${ahora.year}';
  }

  double calcularTotal() {
    double total = 0;

    for (var gasto in gastos) {
      total += gasto.monto;
    }

    return total;
  }

  double totalPorCategoria(String categoria) {
    double total = 0;

    for (var gasto in gastos) {
      if (gasto.categoria == categoria) {
        total += gasto.monto;
      }
    }

    return total;
  }

  String obtenerInsight() {
    double cafe = totalPorCategoria('Café');

    if (cafe >= 300) {
      return 'Cuidado, tus gastos en café están aumentando.';
    } else if (calcularTotal() >= 1000) {
      return 'Has gastado bastante este mes. Revisa tus gastos hormiga.';
    } else {
      return 'Tus gastos están bajo control.';
    }
  }

  void agregarGasto() {
    if (montoController.text.isEmpty) return;

    final double? monto = double.tryParse(montoController.text);

    if (monto == null) return;

    setState(() {
      gastos.add(
        Gasto(
          monto: monto,
          categoria: categoriaSeleccionada,
          nota: notaController.text,
        ),
      );
    });

    montoController.clear();
    notaController.clear();

    Navigator.pop(context);
  }

  void abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Agregar gasto',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(
                value: categoriaSeleccionada,
                items: categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categoriaSeleccionada = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: notaController,
                decoration: const InputDecoration(
                  labelText: 'Nota',
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: agregarGasto,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF6A93BE),
                ),
                child: const Text(
                  'Guardar gasto',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = calcularTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos Hormiga'),
        backgroundColor: const Color(0xFF6A93BE),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                obtenerMesActual(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF6A93BE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total gastado',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Color(0xFF6A93BE)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      obtenerInsight(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historial de gastos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: gastos.isEmpty
                  ? const Center(
                      child: Text('Aún no has registrado gastos.'),
                    )
                  : ListView.builder(
                      itemCount: gastos.length,
                      itemBuilder: (context, index) {
                        final gasto = gastos[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFF6A93BE),
                              child: Icon(Icons.money, color: Colors.white),
                            ),
                            title: Text(gasto.categoria),
                            subtitle: Text(
                              gasto.nota.isEmpty ? 'Sin nota' : gasto.nota,
                            ),
                            trailing: Text(
                              '\$${gasto.monto.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirFormulario,
        backgroundColor: const Color(0xFF6A93BE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}