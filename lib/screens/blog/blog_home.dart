import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sinfagram/models/blog_shrink_model.dart';
import 'package:sinfagram/widgets/blog_element.dart';
import 'package:sinfagram/widgets/ctag.dart';
import 'package:sinfagram/widgets/featured_blog.dart';

class BlogHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Bloglar",
          style: TextStyle(color: Colors.black),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                featuredElement(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 34, bottom: 16),
                      child: Text(
                        "Ommabop",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 34, bottom: 16, right: 8),
                      child:
                          TextButton(onPressed: () {}, child: Text("Koʻproq")),
                    )
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return BlogElement(
                        title: allData[index].title,
                        comments: allData[index].comments,
                        author: allData[index].author,
                        time: allData[index].time,
                        text: allData[index].text,
                        image: allData[index].image,
                        tagName: allData[index].tName,
                        tagColor: allData[index].tColor,
                      );
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 34, bottom: 16),
                      child: Text(
                        "Soʻnggi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, top: 34, right: 8.0),
                      child:
                          TextButton(onPressed: () {}, child: Text("Koʻproq")),
                    )
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return BlogElement(
                        title: allData[index].title,
                        comments: allData[index].comments,
                        author: allData[index].author,
                        time: allData[index].time,
                        text: allData[index].text,
                        image: allData[index].image,
                        tagColor: allData[index].tColor,
                        tagName: allData[index].tName,
                      );
                    }),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 34, bottom: 16),
                  child: Text(
                    "Kashf etish",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: tagBuild("Dasturlash", Colors.pink, context)),
                        Expanded(
                            child: tagBuild("Sayohat", Colors.blue, context)),
                        Expanded(
                            child: tagBuild("Flutter", Colors.orange, context))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: tagBuild("Dizayn", Colors.green, context)),
                        Expanded(child: tagBuild("Sanʼat", Colors.cyan, context)),
                        Expanded(child: tagBuild("React", Colors.red, context))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: tagBuild("Texnologiya", Colors.purple, context)),
                        Expanded(
                            child:
                                tagBuild("Linux", Colors.deepOrange, context)),
                        Expanded(
                            child: tagBuild(
                                "Koʻproq", Colors.deepPurpleAccent, context))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // BlogElement()
        ],
      ),
    );
  }
}
