![](flutter_logo.png)
# Flutter ePortfolio

Welcome to my introduction into the world of Flutter, this repository will guide you through your first contact with Dart, Widgets and app building, and hopefully, help with understanding the basics.

You can use the [handout](handout.pdf) and the [PowerPoint](Flutter.pptx) to learn more about Flutter.

## Backend
For the live demo, I will be using the endpoint you can find in src/backend. It is a simple python server that gathers information from other endpoints and exposes the necessary data to us. You should be able to find the backend [here](https://strong-thorn-planet.glitch.me/). If the backend does not work, you would have to deploy it again for the demo to work.

## Set-up
If you would like to build the App for yourself, step by step, follow this simple guide.

0. Initial set-up
    - Before you can start, make sure to follow the [Get started](https://flutter.dev/docs/get-started/install) section of the official Flutter docs. Make sure to have a working instance of Android Studio as well as Flutter running on your computer.
    - Check the connectivity to the given backend [https://strong-thorn-planet.glitch.me/](https://strong-thorn-planet.glitch.me/)
1. Create a new project
    - Open Android Studio and press "Start a new Flutter project."
    - Select "Flutter Application"
    - Give the App a name and description and select the SDK path, eg. C:\flutter\ or press "Install SDK..." if necessary
    - Select a package name and press finish
2. Clean up the project
    - Remove all the unnecessary comments and functions in the generated main.dart file
    - Launch the emulator and on it the code to check if the application is working and running
3. Create your model
    - Add a new dart file via double shift 'new dart' or 'right-click on the lib folder, new, Dart file' and name it model.dart
    - Add our model code:
    ```dart
    class Pokemon {
        String name;
        String description;
        String image;
        List<String> type;

        Pokemon(this.name, this.description, this.image, this.type);

        factory Pokemon.fromJson(dynamic json) {
            return Pokemon(json['name'], json['description'], json['image'], List.from(json["types"]));
        }
    }
    ```
4. Install http
    - Open pubspec.yaml and enter the line `http: ^0.12.1` under `dependencies:` 
    - Run pub get
5. Create your controller
    - Repeat step 3.1 name it controller.dart
    - Add our controller code:
    ```dart 
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart';

    import 'model.dart';

    class Controller {


        final Client client = Client();

        Future<List<Pokemon>> getList() async {
            print("Getting body");


            var request = await client.get("https://strong-thorn-planet.glitch.me/pokemon");

            print("Data ${request.statusCode} ${request.body}");

            List<dynamic> pokemon = jsonDecode(request.body);

            var pokemonList = pokemon.map((e) => Pokemon.fromJson(e)).toList();

            print("Fetched ${pokemonList.length} pokemon");

            return pokemonList;
        }
    }
        
    ```
6. Edit our HomePageState
    - Add the controller `Controller _controller = Controller();`
    - Add a FutureBuilder widget with our async function to our Body
    ```dart
      body: Container(
        child: FutureBuilder(
          future: _controller.getList(),
          builder: (context, snapshot) {
            if(snapshot.data == null) {
              return Container(
                child: Center(
                  child: RaisedButton(
                    onPressed: () => {
                      print("Pressed"),
                      setState(() {}),
                    },
                      child: Text('Loading')
                  ),
                ),
              );
            }
    ```
    - Build the ListView with the data
    ```dart
        return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                        return ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                            snapshot.data[index].image,
                            ),
                        ),
                        title: Text(snapshot.data[index].name.toString()),
                        );
                    },
                    );
                },
                ),
            ),
            );
        }
    }
    ```
7. Add a string extension
    - To capitalize each name of our pokemon create a new extension in our model class
    ```dart
    extension StringExtension on String {
        String capitalize() {
            return "${this[0].toUpperCase()}${this.substring(1)}";
        }
    }
    ```
    - Apply the new extension to the name `Pokemon(json['name'].toString().capitalize()..`
8. Add a detail page
    - Use Step 3.1 and name the file DetailPage.dart
    - Enter `stless` to autogenerate a Stateless Widget with the help of your IDE
    - Enter DetailPage as the class name
    - Enter the code
    ```dart
    class DetailPage extends StatelessWidget {
        final Pokemon pokemon;

        DetailPage(this.pokemon);

        @override
        Widget build(BuildContext context) {
            return Scaffold(
            appBar: AppBar(
                title: Text(pokemon.name),
            ),
            body: Column(
                children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image(
                    image: NetworkImage(
                        pokemon.image
                    ),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,

                    ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(pokemon.name,
                    style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 72),),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(pokemon.description,
                    style: Theme.of(context).textTheme.subtitle1,),
                ),
                ],
            ),
            );
    ```
9. Add Navigation to our DetailPage
    - In our HomePage we will add an on-tap event
    ```dart
    return ListTile(
            leading: CircleAvatar(
            backgroundImage: NetworkImage(
                snapshot.data[index].image,
            ),
            ),
            title: Text(snapshot.data[index].name.toString()),
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))),
        );
    ```
10. Done

## Links
Take a look at [official Flutter docs](https://flutter.dev/docs) for more information.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)