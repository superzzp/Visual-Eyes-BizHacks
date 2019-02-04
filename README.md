# Visual Eyes

**Powered by Azure Cognitive Services, ARKIT2 and Firebase**

Eye-tracking and emotion prediction of user's reaction to marketing materials. Dynamically store user's picture and reaction data at backend. Proof of concept at _BizHacks_. 

**First Place**, *Best Buy Price Winner* out of 400+ people.

<!--[![Visual Eyes](https://img.youtube.com/vi/ALl_-Kd7OM8/0.jpg)](https://www.youtube.com/watch?v=ALl_-Kd7OM8)-->
Video demo incoming</br>

*Click the image above to watch a demo*

## Architecture

<!--![Architecture](https://github.com/dandua98/MSNewsAR/blob/master/common/images/architecture.jpg)-->
<!---->
<!--*Architecture diagram drawn by [Mai Matsuhisa](https://github.com/MAIMAI728)*-->
Architecture diagram incoming</br>

The frontend tracks the user's eye tracing data, and calculate the coordinates of the points users are looking at on the plane. It is also taking a picture of users every 5 seconds, and uses Azure face detection APIs from
cognitive services to predict user's age and emotion during the period. All the user data generated with the app are stored and uploaded to Firebase for future analysis and data visualization.
