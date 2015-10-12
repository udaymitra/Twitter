### Week 4 Project: Twitter Redux

Time spent 20 hours

I spent almost 8 hours to get paging working in profile view.
Spent 6 hours to get this working with scroll view. Clearly was doing something wrong there.
The last 2 hours I tried switching that to table view with custom cells for banner and profile details. Ran into some edge cases with states for the segmented controller.

Unfortunately, I could not make much headway into optional items this time.

###Implemented the following:

- Hamburger menu
  - Dragging anywhere in the view should reveal the menu.
  - The menu should include links to your profile, the home timeline, and the mentions view.

- Profile page
  - Contains the user header view
  - Contains a section with the users basic stats: # tweets, # followers, # friends, # favorites
  - You can see users tweets and favorites in the profile page (Additional)

- Home Timeline
  - Tapping on a user image should brings up that user's profile page

### Walkthrough:

![alt tag](https://github.com/udaymitra/Twitter/blob/master/walkthrough2.gif)


### Twitter

Twitter client implementation in swift

Implemented all the mandatory and optional requirements for the project

Time spent > 20 hours

### Implemented the following:
- User can sign in using OAuth login flow
- User can view last 20 tweets from their home timeline
- The current signed in user will be persisted across restarts
- In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- User can pull to refresh
- User can compose a new tweet by tapping on a compose button.
- User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
  - images for retweet, favorite and reply change when user interacts with them
- Optional: When composing, character countdown for tweet limit is shown.
  - tweet button becomes inactive if the message is too long
  - display's error message when the tweet is long
- Optional: After creating a new tweet, a user can view it in the timeline immediately without refetching the timeline from the network.
- Optional: Retweeting and favoriting increments the retweet and favorite count.
- Optional: User can unretweet and unfavorite. That decrements the retweet and favorite count.
- Optional: Replies are prefixed with the username
  - in_reply_to_status_id is set when posting the tweet.
- Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

### Walkthrough:

![alt tag](https://github.com/udaymitra/Twitter/blob/master/walkthrough.gif)

### Credits

* [Twitter API](https://dev.twitter.com/rest/public)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
