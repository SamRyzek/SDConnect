package data;

import entities.Profile;


public interface ProfileDAO {
	
	public Profile editUserProfile(int uid, String profileJson);
	public Profile createUserProfile(int uid, String profileJson);
	public Boolean deleteUserProfile(int uid);
	public Profile readUserProfile(int uid);
	

}
