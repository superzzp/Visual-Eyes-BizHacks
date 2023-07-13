# Visual Eyes

**Powered by Azure Cognitive Services, ARKit2, Firebase and React**

Eye-tracking and face analysis in AR, for recording user's focus and predicting user's geographics and emotion when reading marketing materials. Dynamically store and visualize analysis data. Proof of concept at _BizHacks_. 

**First Place**, *Best Buy Price Winner* out of 400+ people.

https://github.com/superzzp/Visual-Eyes-BizHacks/assets/37462732/f7a28fb5-8a66-4e55-9d7e-39ebce916c96

*Click the image above to watch a demo*

![webapp-screenshot](https://github.com/superzzp/Visual-Eyes-BizHacks/assets/37462732/23875575-96b0-4b29-90e4-44a1f1909e8e)

## Architecture

<!--![Architecture](https://github.com/dandua98/MSNewsAR/blob/master/common/images/architecture.jpg)-->
<!---->
<!--*Architecture diagram drawn by [Mai Matsuhisa](https://github.com/MAIMAI728)*-->

The iOS app tracks user's eye, calculates user's focal area and displays it on screen. It is also taking a facial snapshot of users for every 2 seconds, and uses Azure face analysis APIs from
cognitive services to predict user's age, gender and emotion during a set period. All the user data generated by the app are  uploaded to Firebase in real time, grouped by unique usernames and upload times.

In addition, a client website demo serves as a data visualization tool. It can display accumulated user emotions as a pie chart. It is built with React and JavaScript and reads data from the Firebase server and converts it into beautiful graphs built with Plotly.  

## Team Photos

![pics](https://github.com/superzzp/Visual-Eyes-BizHacks/assets/37462732/6a285ca1-8b1d-4f41-aba2-0cb56acae071)
