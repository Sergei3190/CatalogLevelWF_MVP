using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CatalogLevelWF_MVP.Models
{
    public interface ICatalogLevelModel
    {
        List<Catalog_Level> Load_Catalog_Levels();
    }
}
