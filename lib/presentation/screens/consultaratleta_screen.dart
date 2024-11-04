// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element

import 'package:flutter/material.dart';

class ConsultarAtletaScreen extends StatefulWidget {
  const ConsultarAtletaScreen({super.key});

  @override
  _ConsultarAtletaScreenState createState() => _ConsultarAtletaScreenState();
}

class _ConsultarAtletaScreenState extends State<ConsultarAtletaScreen> {

  final List<Map<String, dynamic>> athletes = [
    {'name': 'VINCENT GHEZZAL', 'year': 2000},
    {'name': 'KYLE MARIN', 'year': 2001},
    {'name': 'MUS', 'year': 1999},
    {'name': 'GARY RODRY', 'year': 1998},
    {'name': 'KEVIN DOUGLAS', 'year': 2002},
  ];

  final List<String> filters = ["Ano", "Posição", "Clube", "Rating"];
  int selectedFilter = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('ATLETAS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar atleta por ${filters[selectedFilter].toLowerCase()}',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          filters[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedFilter == index ? Colors.orange : Colors.black,
                          ),
                        ),
                        if (selectedFilter == index)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 20,
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          athletes[index]['name'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${athletes[index]['year']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}