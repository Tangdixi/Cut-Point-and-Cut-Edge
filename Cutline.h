//
//  Cutline.h
//  AppForPointsAndLines
//
//  Created by Developer C on 12/27/12.
//  Copyright (c) 2012 Developer C. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#ifndef AppForPointsAndLines_Cutline_h
#define AppForPointsAndLines_Cutline_h

#define clr(a) memset(a,0,sizeof(a))
#define N 10005
#define M 100005
#define MI(a,b) ((a)>(b)? (b):(a))


struct Node{
    int j, tag, id;
    struct Node *next;
};

int pointCount, lineCount;//vertax count,line count
int nid;//line sign
struct Node mem[M*2];int memp;//mem for save points,memp for index in mem
struct Node *e[N];
int bridge[M];//if index i is 1,then i+1 is the cut line
int nbridge;//cut line amount
int low[N],dfn[N];
int visited[N];//0 for uninterviewed, 1 for interviewed, 2 for interviewed and check the neighbour point

#pragma mark - Cut Line Method

int addEdge (struct Node *e[], int i, int j){
    struct Node *p;
    for (p=e[i]; p!=NULL; p=p->next) {
        if (p->j==j) {
            break;
        }
    }
    if (p!=NULL) {
        p->tag++;
        return 0;
    }
    p=&mem[memp++];
    p->j=j;
    p->next=e[i];
    e[i]=p;
    p->id=nid;
    p->tag=0;
    return 1;
}

void DFS (int i, int father, int dth){
    visited[i]=1;
    dfn[i]=low[i]=dth;
    struct Node *p;
    for (p=e[i]; p!=NULL; p=p->next) {
        int j=p->j;
        if (j!=father && visited[j]==1) {
            low[i]=MI(low[i], dfn[j]);
        }
        if (visited[j]==0) {
            DFS(j, i, dth+1);
            low[i]=MI(low[i], low[j]);
            if (low[j]>dfn[i] && !p->tag) {
                bridge[p->id]=++nbridge;
            }
        }
    }
    visited[i]=2;
}


#endif
