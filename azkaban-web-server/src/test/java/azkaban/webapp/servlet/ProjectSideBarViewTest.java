package azkaban.webapp.servlet;

import azkaban.fixture.FileAssertion;
import azkaban.fixture.MockProject;
import azkaban.fixture.VelocityContextTestUtil;
import azkaban.fixture.VelocityTemplateTestUtil;
import azkaban.fixture.WebFileAssertion;
import azkaban.project.Project;
import org.apache.velocity.VelocityContext;
import org.junit.Test;


/**
 * Test project side bar view
 */
public class ProjectSideBarViewTest {

  /**
   * Test project side bar view.
   *
   * The project description should be HTML encoded to avoid cross site scripting issues.
   *
   * @throws Exception the exception
   */
  @Test
  public void testProjectSideBarView()
      throws Exception {
    final VelocityContext context = VelocityContextTestUtil.getInstance();

    final Project project = MockProject.getMockProject();

    // Intentionally tries to inject a Javascript.
    project.setDescription("<script>window.alert(\"hacked\")</script>");
    context.put("projectName", project.getName());
    context.put("description", project.getDescription());
    context.put("createTimestamp",project.getCreateTimestamp());
    context.put("lastModifiedTimestamp",project.getLastModifiedTimestamp());
    context.put("lastModifiedUser",project.getLastModifiedUser());
    context.put("projectUploadLock", project.isUploadLocked());
    context.put("adhocUpload", project.isAdhocUploadEnabled());
    context.put("showUploadLockPanel", true);

    context.put("admins", "admin_name");
    context.put("userpermission", "admin_permission");

    final String result = VelocityTemplateTestUtil.renderTemplate("projectsidebar", context);
    final String actual = FileAssertion.surroundWithHtmlTag(result);
    WebFileAssertion.assertStringEqualFileContent("project-side-bar.html", actual);
  }
}
