package data;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

import entities.Profile;
import entities.User;

@Transactional
@Repository
public class ProfileDAOImpl implements ProfileDAO {

	@PersistenceContext
	private EntityManager em;

	@Override
	public Profile editUserProfile(int uid, String profileJson) {

		User u = em.find(User.class, uid);

		Profile p = u.getProfile();
		if (u.getId() == uid) {

			ObjectMapper mapper = new ObjectMapper();

			try {

				Profile mappedProfile = mapper.readValue(profileJson, Profile.class);

				if (!mappedProfile.getBackgroundDescription().equals("")) {
					p.setBackgroundDescription(mappedProfile.getBackgroundDescription());
				}

				// *********************************************************
				p.setImg(mappedProfile.getImg());
				p.setBackgroundDescription(mappedProfile.getBackgroundDescription());
				p.setFname(mappedProfile.getFname());
				p.setLname(mappedProfile.getLname());
				p.setPreviousIndustry(mappedProfile.getPreviousIndustry());
				p.setCodingExperience(mappedProfile.getCodingExperience());
				p.setShirtSize(mappedProfile.getShirtSize());
				p.setWebsiteUrl(mappedProfile.getWebsiteUrl());
				p.setGithubUrl(mappedProfile.getGithubUrl());
				p.setLinkedinUrl(mappedProfile.getLinkedinUrl());

				// ***********************************************************

				return p;

			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		return null;

	}

	@Override
	public Profile createUserProfile(int uid, String profileJson) {
		// TODO Auto-generated method stub
		ObjectMapper mapper = new ObjectMapper();

		try {
			Profile mappedProfile = mapper.readValue(profileJson, Profile.class);
			mappedProfile.setImg("img/profilePictures/profile.png");
			User u = em.find(User.class, uid);
			
			mappedProfile.setUser(u);

			em.persist(mappedProfile);
			em.flush();
			return mappedProfile;

		} catch (Exception e) {

			e.printStackTrace();
		}

		return null;

	}

	@Override
	public Boolean deleteUserProfile(int uid, int pid) {
		// TODO Auto-generated method stub

		try {
			Profile p = em.find(Profile.class, pid);
			em.remove(p);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public Profile readUserProfile(int uid) {
		// TODO Auto-generated method stub
		return em.find(User.class, uid).getProfile();

	}

	@Override
	public Set<Profile> readAllProfiles() {
		String query = "SELECT p FROM Profile p";
		Set<Profile> profiles = new HashSet<>(em.createQuery(query, Profile.class).getResultList());
		return profiles;
	}

	@Override
	public boolean checkDuplicatedEmail(String userEmail) {
		String query = "SELECT u FROM User u WHERE u.email= :e";
		try {
			User checkUserEmail = em.createQuery(query, User.class).setParameter("e", userEmail).getResultList().get(0);

			if (checkUserEmail != null) { // if there is a user with the given email, return true
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

}
