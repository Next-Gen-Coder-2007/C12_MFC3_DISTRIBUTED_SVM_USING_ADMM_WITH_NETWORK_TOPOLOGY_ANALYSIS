# Effect of Network Topology on the Performance of ADMM-Based SVMs

<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/en/4/4f/Amrita_Vishwa_Vidyapeetham_Logo.png" width="200">
</p>

---

## Course Information
**Course:** 22MAT220 – Mathematics for Computing 3  
**Institution:** Amrita Vishwa Vidyapeetham  

---

# Team Members

| Name | Roll Number | Course | Program |
|-----|-----|-----|-----|
| Arepalle Charan Kumar Reddy | CB.SC.U4AIE24207 | Mathematics for Computing 3 | B.Sc Artificial Intelligence |
| Naveen K | CB.SC.U4AIE24235 | Mathematics for Computing 3 | B.Sc Artificial Intelligence |
| Sai Kushal B | CB.SC.U4AIE24252 | Mathematics for Computing 3 | B.Sc Artificial Intelligence |
| Subash B | CB.SC.U4AIE24254 | Mathematics for Computing 3 | B.Sc Artificial Intelligence |

---

# Table of Contents

1. Abstract  
2. Introduction  
3. Methodology  
4. Dataset  
5. Results  
6. Conclusion  
7. References  

---

# Abstract

Distributed Support Vector Machines (SVMs) implemented using the **Alternating Direction Method of Multipliers (ADMM)** allow machine learning models to be trained across multiple computing nodes. This project investigates how **network topology influences the convergence and efficiency of distributed SVM training**.

Different graph structures such as **random d-regular graphs and Ramanujan-like graphs** were generated and analyzed. Performance was evaluated using metrics such as **iteration count, runtime, and convergence behavior** across multiple datasets. Experimental results show that **graph spectral properties, particularly the spectral gap (λ₂), significantly influence ADMM convergence speed**. Better connected graphs achieve faster consensus and improved efficiency.

---

# Introduction

Support Vector Machines (SVMs) are widely used supervised learning algorithms for classification tasks. Traditional SVM training assumes that all data is centrally available. However, in many real-world scenarios such as distributed systems, cloud computing, or privacy-sensitive environments, storing and processing all data in one location is impractical.

Distributed machine learning addresses this problem by dividing the dataset across multiple nodes. Each node trains a local model using its own data while collaborating with other nodes to obtain a **global consensus model**.

The **Alternating Direction Method of Multipliers (ADMM)** is an optimization framework commonly used for distributed machine learning. It allows nodes to solve local optimization problems while enforcing agreement between their solutions.

However, the efficiency of ADMM-based distributed learning depends strongly on the **communication network topology** connecting the nodes. Graph properties such as **connectivity and spectral gap** determine how quickly information propagates through the network.

This project studies the relationship between **network topology and ADMM convergence**, combining theoretical analysis with MATLAB simulations.

---

# Methodology

The project follows a four-stage experimental pipeline.

## 1. Network Topology Generation

Communication networks are modeled as **d-regular expander graphs**.

Two types of graphs are studied:

- Random d-regular graphs  
- Ramanujan-like graphs  

Each graph is characterized by:

- Number of nodes  
- Graph degree (d)  
- Spectral gap (λ₂)  

The spectral gap measures the **connectivity strength of the graph**. Larger spectral gaps allow faster information propagation between nodes.

---

## 2. Support Vector Machine Formulation

The soft-margin SVM optimization problem is:

min_w (1/2)||w||² + C Σ max(0 , 1 − y_i wᵀx_i)

Where:

- x_i = feature vector  
- y_i = class label (-1 or +1)  
- w = weight vector  
- C = regularization parameter  

This formulation balances margin maximization and classification error.

---

## 3. Distributed Optimization

The dataset is partitioned across **N computing nodes**.

Each node maintains its own local model:

w₁ , w₂ , ... , wN

The distributed optimization problem becomes:

min Σ f_i(w_i)

subject to

w_i = z

where **z** represents the global consensus model.

---

## 4. ADMM Algorithm

ADMM solves the distributed problem through three iterative updates.

### Local Update
Each node solves a local optimization problem.

### Global Consensus Update
The global model is updated by averaging the local models.

### Dual Variable Update
Dual variables track disagreement between local and global models.

Iterations continue until **primal and dual residuals fall below predefined thresholds**.

---

## MATLAB Implementation

The complete workflow is implemented in MATLAB using:

main.mlx

Key implementation steps include:

- Dataset loading  
- Graph topology generation  
- Distributed ADMM training  
- Performance evaluation  
- Visualization of results  

---

# Dataset

Two dataset groups were used in the experiments.

---

## G1 – Small Datasets

| Dataset | Training Samples | Testing Samples | Features |
|--------|--------|--------|--------|
| Ionosphere | 300 | 51 | 34 |
| svmguide | 3089 | 4000 | 4 |

Training was performed on **16-node networks** with graph degrees:

d = {3, 5, 7, 9, 11, 13, 15}

---

## G2 – Large Datasets

| Dataset | Training Samples | Testing Samples | Features |
|--------|--------|--------|--------|
| phishing | 11055 | 11055 | 68 |
| a9a | 32561 | 16281 | 123 |
| ijcnn | 49990 | 91701 | 22 |
| skinNonskin | 245057 | 50859 | 3 |

Training was performed on **128-node networks** with graph degrees:

d = {10, 20, 30, 40, 60, 80, 90}

---

# Results

## Spectral Gap Analysis

Experiments show that the **spectral gap increases as graph degree increases**.

Ramanujan graphs achieve spectral gaps close to the theoretical upper bound, demonstrating strong connectivity.

---

## Iteration Analysis

For **small datasets (G1)**:

- Larger spectral gaps reduce ADMM iterations.  
- Poorly connected graphs require more iterations.

For **large datasets (G2)**:

- ADMM converges in a single iteration.  
- Graph topology has minimal impact on convergence.

---

## Runtime Analysis

Runtime depends on a trade-off between:

- Connectivity  
- Communication overhead  

Observations:

- Sparse graphs → slow convergence  
- Very dense graphs → high communication cost  
- Moderate degrees → best performance  

---

## Topology Effect

The experiments confirm that **ADMM convergence is influenced more by spectral gap than by graph degree itself**.

Graphs with stronger connectivity enable faster consensus among distributed nodes.

---

# Conclusion

This project demonstrates the relationship between **network topology and distributed optimization performance**.

Key conclusions:

- Spectral gap significantly affects ADMM convergence speed.  
- Ramanujan graphs provide near-optimal connectivity for distributed learning.  
- Small datasets show strong topology effects.  
- Large datasets converge rapidly regardless of topology.  
- Moderate graph degrees offer the best balance between connectivity and communication overhead.

These results highlight the importance of **network design in distributed machine learning systems**.

---

# References

1. Boyd, S., Parikh, N., Chu, E., Peleato, B., & Eckstein, J.  
   Distributed Optimization and Statistical Learning via the Alternating Direction Method of Multipliers.

2. LIBSVM Dataset Repository  
   https://www.csie.ntu.edu.tw/~cjlin/libsvm/

3. MATLAB Documentation  
   https://www.mathworks.com/help/

4. Spectral Graph Theory Literature