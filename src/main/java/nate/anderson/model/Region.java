package nate.anderson.model;

import java.util.UUID;

public class Region {

	private UUID guidEntity;
	private String nameEntity;
	private UUID guidTimePeriod;
	private UUID guidEntityType;
	
	public Region() {

	}

	public UUID getGuidEntity() {
		return guidEntity;
	}

	public void setGuidEntity(UUID guidEntity) {
		this.guidEntity = guidEntity;
	}

	public String getNameEntity() {
		return nameEntity;
	}

	public void setNameEntity(String nameEntity) {
		this.nameEntity = nameEntity;
	}

	public UUID getGuidTimePeriod() {
		return guidTimePeriod;
	}

	public void setGuidTimePeriod(UUID guidTimePeriod) {
		this.guidTimePeriod = guidTimePeriod;
	}

	public UUID getGuidEntityType() {
		return guidEntityType;
	}

	public void setGuidEntityType(UUID guidEntityType) {
		this.guidEntityType = guidEntityType;
	}
	
}
