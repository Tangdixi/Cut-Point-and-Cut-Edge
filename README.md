#iOS 
#Author:Tangdixi

Cut-Point-and-Cut-Edge
======================

Use the DFS algorithm to make a graph traversal. And use the Tarjan algorithm to find the cut edge from a graph.
Two core function were written by C basic on DFS (Depth First Search),both of them were recursion function.

======================
###DFS algorithm
         //  void DFS (int i, int father, int dth){
         //          visited[i]=1;
         //          dfn[i]=low[i]=dth;
         //          struct Node *p;
         //          for (p=e[i]; p!=NULL; p=p->next) {
         //          int j=p->j;
         //          if (j!=father && visited[j]==1) {
         //                  low[i]=MI(low[i], dfn[j]);
         //              }
         //          if (visited[j]==0) {
         //                  DFS(j, i, dth+1);
         //                  low[i]=MI(low[i], low[j]);
         //                  if (low[j]>dfn[i] && !p->tag) {
         //                          bridge[p->id]=++nbridge;
         //                    }
         //                  }
         //          }
         //          visited[i]=2;
         //      }

...................


====================

When you touch the screen, A UIButton will appear on the screen, and use the QuartzCore Framework to draw the edge.

====================
