using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CatalogLevelWF_MVP.Models
{
    public class CatalogLevelModel : ICatalogLevelModel
    {
        List<Catalog_Level> ICatalogLevelModel.Load_Catalog_Levels()
        {
            using (var connect = new CatalogLevel_WFContainer())
            {
                var res = connect.Catalog_Level.ToList();

                return res;
            }
        }
    }
}
