import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/Comment.dart';
import 'package:online_shop/ProfilePage.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/product.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Comment {
  late String userName;
  late String textComment;
  late String date;
  late int productID;
  late int userID;
  late int commentID;
  late int likes;
  late int dislikes;

  Comment.expert(
    this.commentID,
    this.textComment,
    this.date,
    this.userName,
  );
  Comment.user(
    this.commentID,
    this.textComment,
    this.date,
    this.userName,
    this.likes,
    this.dislikes,
  );
}
