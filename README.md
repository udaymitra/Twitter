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
