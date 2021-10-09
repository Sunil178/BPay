import 'package:flutter/material.dart';
import 'package:markets/src/helpers/helper.dart';

class SharedProduct extends StatelessWidget {
  final String url;
  final String name;
  final String price;
  final String desc;
  final String market;

  SharedProduct({this.url, this.name, this.price, this.desc, this.market});

  @override
  Widget build(BuildContext context) {
    print(desc);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                semanticLabel: "jhgygyuyggyugyu",
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            market,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Helper.getPrice(
                            double.parse(price),
                            context,
                            style: Theme.of(context).textTheme.headline2,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  Helper.skipHtml(desc),
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            child: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Positioned(
          //     width: MediaQuery.of(context).size.width,
          //     bottom: 10,
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 32),
          //       child: RaisedButton(
          //         onPressed: () {
          //           Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 16),
          //           child: Text('Go back to home screen'),
          //         ),
          //       ),
          //     ))
        ],
      ),
    );
  }
}
