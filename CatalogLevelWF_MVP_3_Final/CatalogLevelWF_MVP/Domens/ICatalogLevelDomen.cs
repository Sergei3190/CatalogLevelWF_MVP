using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CatalogLevelWF_MVP.Presenters;
using CatalogLevelWF_MVP.Models;
using System.Windows.Forms;

namespace CatalogLevelWF_MVP.Domens
{
    public interface ICatalogLevelDomen
    {
        List<TreeNode> AddTreeNodes(List<Catalog_Level> catalog_Levels);
    }
}
