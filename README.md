# chatt

Flutter Project - Chat Application.

#Project Structure

1 - Main Code is placed inside the lib folder.

2 - I have made a features folder to maintain the main features of the app in a seperate folder.

3 - In the features folder , every folder have three main folder :

    a: Provider - It contains all the business login and api calling, data storage etc.

    b: View - It contains the Screens/UI of the respected functinality.

    c: Model - It contains the models defined according to the response.

4 - Core folder contains the theme logic and color codes.

5 - Services folder contains the local storage service class for the app, in this app we are storing the userinfo to check if the user is currently logged in or not.

6 - Helpers folder is created to handle some commom widgets and snackbars.

7 - Provider is used as the state managemet tool acroos the app.

8 - To run the app , we just need to install the packages by pressing the ctrl+s / cmnd+s in the pub.dev file.

Challenges Faced.

It was a bit new to use the firebase as the complete backend , No major challenges faced.

Functinality: 
User has to login to use the app, after login user will be redirected to the chat page on which user will see the ongoing chats with different users, on clicking on a chat list tile it will redirect to the chat detail where user can see the chat history , each message container has a time attached . Messages are ordered using the timestamp .

On the chat screen we have floating action button to navigate to the users screen, from users screen we can select a user to chat with him.We can search a user using it's name.

Then we have a drawer which contains user name and email with profile photo if uploaded. And a logout button to exit the App.



