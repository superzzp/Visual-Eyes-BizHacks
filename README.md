# Visual Eyes

**Powered by Azure Cognitive Services, ARKit2 and Firebase**

Eye-tracking and face analysis in AR, for recording user's focus and predicting user's geographics and emotion when reading marketing materials. Dynamically store analysis results at backend. Proof of concept at _BizHacks_. 

**First Place**, *Best Buy Best Hacks* out of 400+ people.

[![Visual Eyes](https://img.youtube.com/vi/dHPioO0KVxE/0.jpg)](https://www.youtube.com/watch?v=dHPioO0KVxE)

*Click the image above to watch a demo*

## Architecture

<!--![Architecture](https://github.com/dandua98/MSNewsAR/blob/master/common/images/architecture.jpg)-->
<!---->
<!--*Architecture diagram drawn by [Mai Matsuhisa](https://github.com/MAIMAI728)*-->

The frontend tracks the user's eye tracing data, and calculate the coordinates of the points users are looking at on the plane. It is also taking a picture of users every 5 seconds, and uses Azure face detection APIs from
cognitive services to predict users' age, sex and emotion during the period. All the user data generated with the app are stored and uploaded to Firebase for future analysis and data visualization.
