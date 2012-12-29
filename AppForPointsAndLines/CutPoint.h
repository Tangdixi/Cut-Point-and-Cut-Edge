//
//  CutPoint.h
//  AppForPointsAndLines
//
//  Created by Developer C on 12/27/12.
//  Copyright (c) 2012 Developer C. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#ifndef AppForPointsAndLines_CutPoint_h
#define AppForPointsAndLines_CutPoint_h

#define MI(a,b) ((a)>(b)? (b):(a))
int Edge[1001][1001];//martrix
int visited_point[1001];//interview state
int nodes;//vertax count
int tmpdfn;//current search depth level
int dfn_points[1001];
int low_points[1001];
int son;//sub vertar count from source
int subnets[1001];//

void DFS_Points (int u){
    for (int v=1; v<=nodes; v++) {
        if (Edge[u][v]) {
            if (!visited_point[v]) {
                visited_point[v]=1;
                tmpdfn++;
                dfn_points[v]=low_points[v]=tmpdfn;
                DFS_Points(v);
                low_points[u]=MI(low_points[u], low_points[v]);
                if (low_points[v]>=dfn_points[u]) {
                    if (u!=1) {subnets[u]++;}
                    if (u==1) {son++;}
                }
            }
            else{
                low_points[u]=MI(low_points[u], dfn_points[v]);
            }
        }
    }
}

void init(){
    low_points[1]=dfn_points[1]=1;
    tmpdfn=1; son=0;
    memset(visited_point, 0, sizeof(visited_point));
    visited_point[1]=1;
    memset(subnets, 0, sizeof(subnets));
}

#endif
