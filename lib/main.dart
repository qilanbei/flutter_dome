// welcome to Flutter
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      // Scaffold 是 Material 库中提供的一个 widget，它提供了默认的导航栏、标题和包含主屏幕 widget 树的 body 属性
      // 整个主题背景将会变为白色
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords()
    );
  }
}
// 一个 State 类，StatefulWidget 类本身是不变的，但是 State 类在 widget 生命周期中始终存在。
class _RandomWordsState extends State<RandomWords> {
  // Stateless widgets 是不可变的，这意味着它们的属性不能改变 —— 所有的值都是 final。
  final _suggestions = <WordPair>[];
  // 这个集合存储用户喜欢（收藏）的单词对。 在这里，Set 比 List 更合适，因为 Set 中不允许重复的值
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);
  // （当用户点击导航栏中的列表图标时）我们会建立一个路由并将其推入到导航管理器栈中
  // 新页面的内容会在 MaterialPageRoute 的 builder 属性中构建，builder 是一个匿名函数
  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                )
              );
            }
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      )
    );
  }
  Widget _buildSuggestions() {
    // 对于每个建议的单词对都会调用一次 itemBuilder
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // 在奇数行，该函数会添加一个分割线的 widget，来分隔相邻的词对
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);  // 来检查确保单词对还没有添加到收藏夹中
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ]
      ),
      body: _buildSuggestions(),
    );
  }
}

// Stateful widgets 持有的状态可能在 widget 生命周期中发生变化

// 实现一个 stateful widget 至少需要两个类
// 1. 一个 StatefulWidget 类
class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
