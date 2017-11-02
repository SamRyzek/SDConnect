package entities;

import java.sql.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;

@Entity
public class Cohort {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	private String name;
	
	@Column(name="start_date")
	private Date startDate;
	
	@Column(name="end_date")
	private Date endDate;
	
	@Column(name="cohort_num")
	private int cohortNum;
	
	@Column(name="mascot_img_url")
	private String mascotImgUrl;
	
	//one cohort has many users
	@OneToMany(mappedBy="cohort")
	List<User> users;
	
	@ManyToMany
	@JoinTable(name="cohort_has_events",
	joinColumns=@JoinColumn(name="cohort_id"),
	inverseJoinColumns=@JoinColumn(name="event_id")
			)
	private List<Event> eventList;

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	public List<Event> getEventList() {
		return eventList;
	}

	public void setEventList(List<Event> eventList) {
		this.eventList = eventList;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public int getCohortNum() {
		return cohortNum;
	}

	public void setCohortNum(int cohortNum) {
		this.cohortNum = cohortNum;
	}

	public String getMascotImgUrl() {
		return mascotImgUrl;
	}

	public void setMascotImgUrl(String mascotImgUrl) {
		this.mascotImgUrl = mascotImgUrl;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Cohort [id=");
		builder.append(id);
		builder.append(", name=");
		builder.append(name);
		builder.append(", startDate=");
		builder.append(startDate);
		builder.append(", endDate=");
		builder.append(endDate);
		builder.append(", cohortNum=");
		builder.append(cohortNum);
		builder.append("]");
		return builder.toString();
	}

}
