package bluesky.server.service;

import com.netflix.curator.framework.api.ACLProvider;
import org.apache.zookeeper.ZooDefs;
import org.apache.zookeeper.data.ACL;

import java.util.ArrayList;
import java.util.List;

public class ServiceACLProvider implements ACLProvider {
    private List<org.apache.zookeeper.data.ACL> ACL = new ArrayList<ACL>();

    public ServiceACLProvider() {
        //ACL.addAll(ZooDefs.Ids.CREATOR_ALL_ACL);
        ACL.addAll(ZooDefs.Ids.OPEN_ACL_UNSAFE);
    }

    @Override
    public List<ACL> getDefaultAcl() {  return ACL;  }
    @Override
    public List<ACL> getAclForPath(String path) {  return ACL;  }
}
