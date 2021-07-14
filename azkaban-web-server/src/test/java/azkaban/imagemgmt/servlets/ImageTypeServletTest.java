package azkaban.imagemgmt.servlets;

import static java.util.Objects.requireNonNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.when;

import azkaban.imagemgmt.exception.ImageMgmtInvalidPermissionException;
import azkaban.server.session.Session;
import azkaban.user.Permission;
import azkaban.user.Role;
import azkaban.user.User;
import azkaban.user.UserManager;
import azkaban.user.XmlUserManager;
import azkaban.utils.Props;
import azkaban.webapp.AzkabanWebServer;
import azkaban.webapp.AzkabanWebServerTest;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.junit.Before;
import org.junit.Test;

public class ImageTypeServletTest {

  private ImageTypeServlet imageTypeServlet;
  private HttpServletRequest req;
  private HttpServletResponse resp;
  Session session = new Session(UUID.randomUUID().toString(), new User("azkaban"), "0.0.0.0");

  @Before
  public void setup() throws Exception {
    imageTypeServlet = new ImageTypeServlet();
    req = mock(HttpServletRequest.class);
    resp = mock(HttpServletResponse.class);
  }


  @Test
  public void testHandleGet() throws Exception {
    when(req.getRequestURI()).thenReturn("/imageTypes/imageTypeName");
    imageTypeServlet.handleGet(req, resp, session);
  }

  @Test(expected = ImageMgmtInvalidPermissionException.class)
  public void testHandleGetFailsForNonAzkabanAdminWithNoImageOwner() throws Exception {

    Permission permission = new Permission();
    Role role = new Role("name", permission);
    User user = new User("azkaban");
    List<Permission> permissions = new ArrayList<Permission>();
    permissions.add(permission);


    Props props = new Props();
    props.put("user.manager.xml.file", getUserManagerXmlFile());
    UserManager userManagerMock = spy(XmlUserManager.class);
    AzkabanWebServer azkabanWebServerMock = spy(AzkabanWebServer.class);

    when(req.getRequestURI()).thenReturn("/imageTypes/imageTypeName");
    when(imageTypeServlet.getApplication()).thenReturn(azkabanWebServerMock);
    when(imageTypeServlet.getApplication().getUserManager()).thenReturn(userManagerMock);
    when(imageTypeServlet.hasImageManagementPermission("imageTypeName", user,
        Permission.Type.GET)).thenReturn(false);

    imageTypeServlet.handleGet(req, resp, session);
  }

  @Test(expected = ImageMgmtInvalidPermissionException.class)
  public void testHandleGetFailsForAdmin() throws Exception {
    when(req.getRequestURI()).thenReturn("/imageTypes/imageTypeName");
    when(imageTypeServlet.hasImageManagementPermission(any(String.class), any(User.class),
        any(Permission.Type.class))).thenReturn(false);
    imageTypeServlet.handleGet(req, resp, session);
  }

  private static String getUserManagerXmlFile() {
    final URL resource = ImageTypeServletTest.class.getClassLoader()
        .getResource("azkaban-users.xml");
    return requireNonNull(resource).getPath();
  }


//  @Test
//  public void testHandleGetForImageManagementAdmin() throws Exception {
//    when(req.getRequestURI()).thenReturn("/imageTypes/imageTypeName");
//    when(hasImageManagementPermission)
//    imageTypeServlet.handleGet(req, resp, session);
//  }
//

}
