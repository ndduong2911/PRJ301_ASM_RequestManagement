package model;

public class RoleFeature {

    private int roleId;
    private int featureId;

    public RoleFeature() {
    }

    public RoleFeature(int roleId, int featureId) {
        this.roleId = roleId;
        this.featureId = featureId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getFeatureId() {
        return featureId;
    }

    public void setFeatureId(int featureId) {
        this.featureId = featureId;
    }

}
