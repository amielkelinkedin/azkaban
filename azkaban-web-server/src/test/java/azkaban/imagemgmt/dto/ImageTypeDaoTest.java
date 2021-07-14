package azkaban.imagemgmt.dto;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.eq;
import static org.powermock.api.mockito.PowerMockito.when;

import azkaban.db.DatabaseOperator;
import azkaban.imagemgmt.daos.ImageTypeDao;
import azkaban.imagemgmt.daos.ImageTypeDaoImpl;
import azkaban.imagemgmt.daos.ImageTypeDaoImpl.FetchImageTypeHandler;
import azkaban.imagemgmt.exception.ImageMgmtDaoException;
import azkaban.imagemgmt.models.ImageOwnership;
import azkaban.imagemgmt.models.ImageOwnership.Role;
import azkaban.imagemgmt.models.ImageType;
import azkaban.imagemgmt.models.ImageType.Deployable;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.apache.commons.dbutils.QueryRunner;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

public class ImageTypeDaoTest {

  private ImageTypeDao imageTypeDaoMock;
  private DatabaseOperator databaseOperatorMock;

  @Before
  public void setup() {
    databaseOperatorMock = mock(DatabaseOperator.class);
    imageTypeDaoMock = new ImageTypeDaoImpl(databaseOperatorMock);
  }


  @Test
  public void testGetImageTypeWithOwnershipsByName() throws Exception {
    List<ImageType> its = new ArrayList<ImageType>();
    ImageType it = new ImageType();
    it.setName("name");
    it.setDescription("description");
    it.setDeployable(Deployable.IMAGE);
    ImageOwnership io = new ImageOwnership();
    io.setOwner("owner");
    io.setName("name");
    io.setRole(Role.ADMIN);
    List<ImageOwnership> ios = new ArrayList<>();
    ios.add(io);
    it.setOwnerships(ios);
    its.add(it);
    String name = "imageName";
    when(databaseOperatorMock.query(anyString(), any(FetchImageTypeHandler.class),
        anyString())).thenReturn(its);
    java.util.Optional<ImageType> imageType = imageTypeDaoMock.getImageTypeWithOwnershipsByName(name);
    assert(imageType.isPresent());
    assert(imageType.get().equals(it));

  }

  @Test(expected = ImageMgmtDaoException.class)
  public void testGetImageTypeWithOwnershipsByNameFailsWithMultipleImageTypes() throws Exception {
    List<ImageType> its = new ArrayList<ImageType>();
    ImageType it = new ImageType();
    ImageType it2 = new ImageType();
    it.setName("name");
    it.setDescription("description");
    it.setDeployable(Deployable.IMAGE);
    ImageOwnership io = new ImageOwnership();
    io.setOwner("owner");
    io.setName("name");
    io.setRole(Role.ADMIN);
    List<ImageOwnership> ios = new ArrayList<>();
    ios.add(io);
    it.setOwnerships(ios);
    its.add(it);
    its.add(it2);
    String name = "imageName";
    when(databaseOperatorMock.query(anyString(), any(FetchImageTypeHandler.class),
        anyString())).thenReturn(its);
    java.util.Optional<ImageType> imageType = imageTypeDaoMock.getImageTypeWithOwnershipsByName(name);

  }

  @Test(expected = ImageMgmtDaoException.class)
  public void testGetImageTypeWithOwnershipsByNameFailsWhenQueryResultsAreNull() throws Exception {
    List<ImageType> its = new ArrayList<ImageType>();
    ImageType it = new ImageType();
    ImageType it2 = new ImageType();
    it.setName("name");
    it.setDescription("description");
    it.setDeployable(Deployable.IMAGE);
    ImageOwnership io = new ImageOwnership();
    io.setOwner("owner");
    io.setName("name");
    io.setRole(Role.ADMIN);
    List<ImageOwnership> ios = new ArrayList<>();
    ios.add(io);
    it.setOwnerships(ios);
    its.add(it);
    its.add(it2);
    String name = "imageName";
    when(databaseOperatorMock.query(anyString(), any(FetchImageTypeHandler.class),
        anyString())).thenReturn(null);
    java.util.Optional<ImageType> imageType = imageTypeDaoMock.getImageTypeWithOwnershipsByName(name);

  }

}
