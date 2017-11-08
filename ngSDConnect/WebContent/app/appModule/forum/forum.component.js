angular.module("appModule")
	.component("forum", {
		templateUrl: "app/appModule/forum/forum.component.html",
			
		controller: function(topicService, postService, tagService, $filter, $location, $routeParams){
			var vm = this;
			
			vm.currentTopics = [];
			vm.currentPosts = [];
			vm.allTags = [];
			
			var currentUserToken = postService.returnUser();
			
			vm.currentTid = null;
			vm.currentTopicName = null;
			
			var setEverythingToNull = function(){
				vm.postView = false;
				vm.postSelected = null;
				vm.topicSelected = null;
				vm.newTopic = false;
				vm.newPost = false;
			};
			
			setEverythingToNull();
			
			var getAllTopics = function(){
				topicService.index()
				.then(function(resp){
					vm.currentTopics = resp.data;
				})
				.catch(function(error){
					console.log(error);
				});
			};
			
			getAllTopics();
			
			var getAllTags = function(){
				tagService.index()
				.then(function(resp){
					vm.allTags = resp.data;
				})
				.catch(function(error){
					console.log(error);
				});
			};
			
			getAllTags();
			
			vm.getTopicByTagKeyword = function(word){
				topicService.getTopicByTagKeyword(word)
				.then(function(resp){
					vm.currentTopics = resp.data;
				})
				.catch(function(error){
					console.log(error)
				});
			};
			
			vm.getPostsPerTopic = function(topic) {
				setEverythingToNull();
				vm.currentTid = topic.id;
				vm.currentTopicName = topic.name;
				vm.postView = true;
				postService.index(topic.id)
				.then(function(resp){
					vm.currentPosts = resp.data;
				})
				.catch(function(error){
					console.log(error)
				})
			};
			
			vm.displayTopics = function(){
				vm.currentPosts = [];
				setEverythingToNull();
				getAllTopics();
			};
			
			vm.currentAdmin = function() {
				return currentUserToken.type == 'admin';
			};
			
			vm.currentAuthorPost = function(post) {
				var uid = currentUserToken.id;
				var compare = post.user.id;
				return uid == compare;
			};
			
			vm.editTopic = function(topic) {
				setEverythingToNull();
				vm.topicSelected = topic;
			};
			
			vm.updateTopic = function(topic){
				topicService.update(topic);
				setEverythingToNull();
			};
			
			vm.deleteTopic = function(tid){
				topicService.destroy(tid)
				.then(function(res){
					setEverythingToNull();
					getAllTopics();
				})
				.catch(function(error){
					console.log(error);
				});
			};
			
			vm.createTopic = function(topic){
				delete topic.tag.topics;
				topicService.createTopic(topic)
				.then(function(res){
					setEverythingToNull();
					getAllTopics();
				})
				.catch(function(error){
					console.log(error);
				});
				
			};
			
			var getPost = function(pid) {
				return postService.show(pid)
				.then(function(resp){
					return resp.data;
				})
				.catch(function(error){
					console.log(error);
				});
			}
			
			vm.editPost = function(post){
				setEverythingToNull();
				vm.postSelected = post;
			};
			
			vm.updatePost = function(post){
				postService.update(post)
				.then(function(res){
					vm.currentPosts.push(res.data);
					setEverythingToNull();
					vm.postView = true;
				})
				.catch(function(error){
					console.log(error);
				});
			};
			
			vm.deletePost = function(pid){
				postService.destroy(pid)
				.then(function(res){
					setEverythingToNull();
					getAllTopics();
				})
				.catch(function(error){
					console.log(error);
				});
			};
			
			vm.createPost = function(post){
				console.log("create post")
				postService.create(post, vm.currentTid)
				.then(function(res){
					vm.currentPosts.push(res.data);
					setEverythingToNull();
					vm.postView = true;
					console.log("PID: " + res.data.id);
				})
				.catch(function(error){
					console.log(error);
				});
			};
			
			vm.getClassPostMain = function(num) {
				if(num%2==0) {
					return 'chat-widget-left';
				}
				else {
					return 'chat-widget-right';
				}
			};
			
			vm.getClassPostName = function(num) {
				if(num%2==0) {
					return 'chat-widget-name-left';
				}
				else {
					return 'chat-widget-name-right';
				}
			};
			
			var removePost = function(array, element) {
			    var index = array.indexOf(element);
			    array.splice(index, 1);
			}
			
		},
		
		controllerAs: 'vm'
		
	});

