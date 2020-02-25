using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CatalogLevelWF_MVP.Models;

namespace CatalogLevelWF_MVP.Domens
{
    public class CatalogLevelDomen : ICatalogLevelDomen
    {
        List<TreeNode> ICatalogLevelDomen.AddTreeNodes(List<Catalog_Level> catalog_Levels)
        {
            var nodes = new List<TreeNode>();

            foreach (var item in catalog_Levels)
            {
                if (item.Parent_ID.ToString() == string.Empty)
                {
                    nodes.Add(new TreeNode(item.Name, AddChildNodes(item.ID, catalog_Levels)));
                }
            }

            return nodes;
        }

        private TreeNode[] AddChildNodes(int id, List<Catalog_Level> catalog_Levels)
        {
            var child = new List<TreeNode>();

            foreach (var item in catalog_Levels)
            {
                if (id.ToString() == item.Parent_ID.ToString())
                {
                    child.Add(new TreeNode(item.Name, AddChildNodes(item.ID, catalog_Levels)));
                }
            }

            return child.ToArray();
        }
    }    
}
