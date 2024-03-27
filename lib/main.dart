import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FirstScreenState();
  }
}

class FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                          child: const Text("Представьтесь",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Введите имя";
                              }
                              if (!RegExp(r"^[A-ZА-Я][a-zа-я]*$")
                                  .hasMatch(value)) {
                                return "Имя должно содержать только буквы и начинаться с заглавной";
                              }
                              return null;
                            },
                            controller: _controller,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _controller.text = "";
                                      });
                                    },
                                    icon: const Icon(Icons.clear)),
                                border: const OutlineInputBorder(),
                                labelText: "Ваше имя",
                                hintText: "Введите ваше имя"),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SecondScreen(
                                          name: _controller.text)));
                            }
                          },
                          child: const Text("Войти"))
                    ],
                  )),
            )));
  }
}

class SecondScreen extends StatefulWidget {
  final String name;
  const SecondScreen({super.key, required this.name});

  @override
  State<StatefulWidget> createState() {
    return SecondScreenState(name: name);
  }
}

class SecondScreenState extends State<SecondScreen> {
  final String name;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  DateTime? _date;

  SecondScreenState({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: Text("$name, добро пожаловать!",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: const Text("Укажите вашу дату рождения",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: TextFormField(
                              controller: _controller,
                              keyboardType: TextInputType.none,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Выберите дату";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _controller.text = "";
                                        });
                                      },
                                      icon: const Icon(Icons.clear)),
                                  border: const OutlineInputBorder(),
                                  labelText: "Дата рождения",
                                  hintText: "Выберите дату"),
                              onTap: () async {
                                _date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now());
                                if (_date != null) {
                                  setState(() {
                                    _controller.text = _date.toString().split(" ")[0];
                                  });
                                }
                              },
                            )),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ThirdScreen(
                                            name: name,
                                            age: (DateTime.now()
                                                        .difference(_date!)
                                                        .inDays /
                                                    365)
                                                .floor())));
                              }
                            },
                            child: const Text("Рассчитать возраст"))
                      ],
                    )))));
  }
}

class ThirdScreen extends StatelessWidget {
  final String name;
  final int age;

  const ThirdScreen({required this.name, required this.age, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$name, вам $age лет",
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Вернуться на главную"))
        ],
      )),
    );
  }
}
