Meteor.startup ->
  #if Meteor.users.find().count() is 0
  # first, remove configuration entry in case service is already configured
  ServiceConfiguration.configurations.remove
    service: "facebook"
  ServiceConfiguration.configurations.insert
    service: "facebook"
    appId: "849943885063275"
    secret: "2316435173957cd9044958740eee3307"
  ServiceConfiguration.configurations.remove
    service: "twitter"
  ServiceConfiguration.configurations.insert
    service: "twitter"
    consumerKey: "KHpKKsjygfUQKJbJNkUoGcqY0"
    secret: "07apXJbh0ZHcYoDCFXkjK4gxgdZYyXlulB0mMoZ3ugBbxWYgaR"
