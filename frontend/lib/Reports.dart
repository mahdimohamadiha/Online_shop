import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/product.dart';
import 'package:online_shop/user.dart';

import 'ProfilePage.dart';
import 'main.dart';

class Report {
  late int productId;
  late String productName;
  late int number;
  late String sum;
}

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Future<void> salesAmountNumberProduct(
      int year, int startMonth, int endMonth, int startDay, int endDay) async {
    final Uri url = Uri.parse("${MyApp.url}/sales-amount-number-product");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "year": year,
          "startMonth": startMonth,
          "endMonth": endMonth,
          "startDay": startDay,
          "endDay": endDay,
        }));
    List<dynamic> decoded = json.decode(response.body);
  }

  Future<void> salesAmountCategoryProduct(
      int year, int startMonth, int endMonth, int startDay, int endDay) async {
    final Uri url = Uri.parse("${MyApp.url}/sales-amount-category-product");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "year": year,
          "startMonth": startMonth,
          "endMonth": endMonth,
          "startDay": startDay,
          "endDay": endDay,
        }));
    List<dynamic> decoded = json.decode(response.body);
  }

  Future<void> profitSale(
      int year, int startMonth, int endMonth, int startDay, int endDay) async {
    final Uri url = Uri.parse("${MyApp.url}/profit-sale");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "year": year,
          "startMonth": startMonth,
          "endMonth": endMonth,
          "startDay": startDay,
          "endDay": endDay,
        }));
    List<dynamic> decoded = json.decode(response.body);
  }

  Future<void> periodSatisfaction(
      int year, int startMonth, int endMonth, int startDay, int endDay) async {
    final Uri url = Uri.parse("${MyApp.url}/period-satisfaction");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "startyear": year,
          "endyear": year,
          "startMonth": startMonth,
          "endMonth": endMonth,
          "startDay": startDay,
          "endDay": endDay,
        }));
    List<dynamic> decoded = json.decode(response.body);
  }

  TextEditingController yearCon = TextEditingController();

  TextEditingController startMCon = TextEditingController();

  TextEditingController endMCon = TextEditingController();

  TextEditingController startDCon = TextEditingController();

  TextEditingController endDCon = TextEditingController();

  String container1 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 5)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 10),
                    child: TextField(
                      controller: yearCon,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'year',
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: startMCon,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'start month',
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: endMCon,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'end month',
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: startDCon,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'start day',
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: yearCon,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'end day',
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                            onPressed: () {
                              salesAmountNumberProduct(
                                  int.parse(yearCon.text),
                                  int.parse(startMCon.text),
                                  int.parse(endMCon.text),
                                  int.parse(startDCon.text),
                                  int.parse(endDCon.text));
                            },
                            child: Text('number')),
                      )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                              onPressed: () {
                                salesAmountCategoryProduct(
                                    int.parse(yearCon.text),
                                    int.parse(startMCon.text),
                                    int.parse(endMCon.text),
                                    int.parse(startDCon.text),
                                    int.parse(endDCon.text));
                              },
                              child: Text('category')),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                            onPressed: () {
                              periodSatisfaction(
                                  int.parse(yearCon.text),
                                  int.parse(startMCon.text),
                                  int.parse(endMCon.text),
                                  int.parse(startDCon.text),
                                  int.parse(endDCon.text));
                            },
                            child: Text('satisfaction')),
                      )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                              onPressed: () {
                                profitSale(
                                    int.parse(yearCon.text),
                                    int.parse(startMCon.text),
                                    int.parse(endMCon.text),
                                    int.parse(startDCon.text),
                                    int.parse(endDCon.text));
                              },
                              child: Text('profit')),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      container1,
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
