import'package:flutter/material.dart';

import 'customColors.dart';

const kPrimaryColor = Colors.blueGrey;

const kEventTextFieldDecoration = InputDecoration(
  disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: CustomColor.sea_blue, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: CustomColor.dark_blue, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        hintText: 'eg: Birthday party of John',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        // errorText: isEditingTitle ? _validateTitle(currentTitle) : 'null',
                        // errorStyle: const TextStyle(
                        //   fontSize: 12,
                        //   color: Colors.redAccent,
                        // ),
                      );