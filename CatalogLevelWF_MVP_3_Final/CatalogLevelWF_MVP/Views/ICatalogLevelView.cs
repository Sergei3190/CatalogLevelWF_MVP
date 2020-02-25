using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CatalogLevelWF_MVP.Models;

namespace CatalogLevelWF_MVP.Views
{
    public interface ICatalogLevelView
    {
        void SetTreeNodes(List<TreeNode> treeNodes);
    }
}
