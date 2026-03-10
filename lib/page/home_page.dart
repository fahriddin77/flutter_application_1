import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/team.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Team> teams = [];

  Future<List<Team>> getTeams() async {
    var response = await http.get(
      Uri.https('balldontlie.io', '/api/v1/teams'),
    );

    var jsonData = jsonDecode(response.body);

    teams.clear();

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      teams.add(team);
    }

    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NBA Teams")),
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(teams[index].abbreviation),
                    subtitle: Text(teams[index].city),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}