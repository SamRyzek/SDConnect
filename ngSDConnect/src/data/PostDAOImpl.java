package data;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

import entities.Post;
import entities.Topic;
import entities.User;

@Transactional
@Repository
public class PostDAOImpl implements PostDAO {
	
	@PersistenceContext
	private EntityManager em;

	@Override
	public Set<Post> showAllByTopicId(int topicId) {
		String queryString = "Select p from Post p where p.topic.id = :id";
		List<Post> tempList = em.createQuery(queryString, Post.class)
								.setParameter("id", topicId)
								.getResultList();
		Set<Post> posts = new HashSet<>(tempList);
		return posts;
	}

	@Override
	public Post showPostById(int postId) {
		return em.find(Post.class, postId);
	}

	@Override
	public Post createPost(int userId, int topicId, String postJson) {
		Topic currentTopic = em.find(Topic.class, topicId);
		List<Post> posts;
		if(currentTopic.getPosts().size() == 0) {
			posts = new ArrayList<>();
		}
		else {
			posts = currentTopic.getPosts();
		}
		ObjectMapper mapper = new ObjectMapper();
		User user = getUserById(userId);
		Post mappedPost = null;
		try {
			mappedPost = mapper.readValue(postJson, Post.class);
			mappedPost.setUser(user);
			mappedPost.setTopic(currentTopic);
			mappedPost.setPostDate(new java.sql.Date(new java.util.Date().getTime()));
			em.persist(mappedPost);
			em.flush();
			posts.add(mappedPost);
			currentTopic.setPosts(posts);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return mappedPost;
	}

	@Override
	public Post updatePost(int userId, int postId, String postJson) {
		Post managedPost = em.find(Post.class, postId);
		if(managedPost==null) {
			return null;
		}
		User user = getUserById(userId);
		ObjectMapper mapper = new ObjectMapper();
		Post mappedPost = null;
		try {
			mappedPost = mapper.readValue(postJson, Post.class);
			mappedPost.setUser(user);
			managedPost.setUser(user);
			if(mappedPost.getMessage() != null && mappedPost.getMessage() != "") {
				managedPost.setMessage(mappedPost.getMessage());
			}
			if(mappedPost.getLink() != null && mappedPost.getLink() != "") {
				managedPost.setLink(mappedPost.getLink());
			}
			if(mappedPost.getPostDate() != null) {
				managedPost.setPostDate(mappedPost.getPostDate());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return managedPost;
	}

	@Override
	public boolean deletePost(int userId, int postId) {
		Post managedPost = em.find(Post.class, postId);
		if(managedPost==null) {
			return false;
		}
		String query = "DELETE FROM Post p WHERE p.id = :id";
		em.createQuery(query).setParameter("id", postId).executeUpdate();
		return true;
	}
	
	public User getUserById(int uid) {
		User user = new User();
		String queryString = "Select u from User u where u.id = :uid";
		List<User> tempList = em.createQuery(queryString, User.class)
								.setParameter("uid", uid)
								.getResultList();
		if(tempList.size() > 0) {
			user = tempList.get(0);
		}		
		return user;		
	}
	

	private Topic getTopicById(int topicId) {
		Topic topic = null;
		String queryString = "Select t from Topic t where t.id = :id";
		List<Topic> tempList = em.createQuery(queryString, Topic.class)
								.setParameter("id", topicId)
								.getResultList();
		if(tempList.size() > 0) {
			topic = tempList.get(0);
		}		
		return topic;	
	}

}
