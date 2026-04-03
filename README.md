# Distributed SVM using ADMM with Network Topology Analysis

## Overview
This project implements a distributed machine learning framework for training a Support Vector Machine (SVM) using the ADMM (Alternating Direction Method of Multipliers) optimization technique. The system distributes data across multiple nodes, enabling parallel training while ensuring global model consistency.

The project also analyzes how different network topologies influence convergence speed, communication efficiency, and overall model performance.

---

## Objectives
- Implement distributed SVM training using ADMM  
- Enable parallel computation across multiple nodes  
- Study the impact of network topology on convergence  
- Evaluate performance using real-world benchmark datasets  
- Analyze spectral properties (e.g., Laplacian, λ₂) of graphs  

---

## Key Concepts
- Distributed Machine Learning  
- Support Vector Machine (SVM)  
- ADMM Optimization  
- Graph Theory and Network Topology  
- Spectral Graph Analysis  
- Consensus Algorithms  

---

## Tech Stack
- Programming Language: MATLAB  
- Algorithms: SVM (RBF Kernel), ADMM  
- Concepts: Graph Laplacian, Spectral Gap  
- Datasets: a9a, ijcnn1, ionosphere, phishing, svmguide1  

---

## Project Structure

├── consensus_admm_svm.m # Core distributed SVM using ADMM
├── gridsearch_cv_admm_svm.m # Hyperparameter tuning
├── predict_svm_rbf.m # Prediction using trained SVM
├── laplacian.m # Graph Laplacian computation
├── random_d_regular_graph.m # Network topology generation
├── plot_topology_effect.m # Visualization of topology impact
├── datasets/ # Benchmark datasets
└── results/ # Output graphs and analysis


---

## How It Works
1. Data is distributed across multiple nodes  
2. Each node trains a local SVM model  
3. ADMM is used to:
   - Enforce consensus between nodes  
   - Optimize a global objective function  
4. Different network topologies are applied  
5. Performance is evaluated based on:
   - Convergence speed  
   - Accuracy  
   - Communication efficiency  

---

## Key Features
- Distributed training using ADMM  
- Supports multiple network topologies  
- Hyperparameter tuning with cross-validation  
- Visualization of convergence behavior  
- Graph-based performance analysis  

---

## Results and Insights
- Network topology significantly impacts training convergence  
- Higher spectral gap (λ₂) leads to faster convergence  
- Efficient graph structures reduce communication overhead  
- Distributed approach scales better than centralized training  

---

## Future Enhancements
- Integrate Flask and React dashboard for visualization  
- Extend to deep learning models (distributed neural networks)  
- Real-time network simulation and monitoring  
- Deploy as a cloud-based distributed ML system  

---

## How to Run
1. Open MATLAB  
2. Load the project folder  
3. Run the main script:
   ```matlab
   consensus_admm_svm

Visualize results using:

plot_topology_effect
Applications
Distributed AI systems
Large-scale data processing
Edge computing and IoT
Federated learning environments
Authors
Subash B
Team Members
Conclusion

This project demonstrates how distributed optimization techniques like ADMM can efficiently train machine learning models while highlighting the critical role of network topology in system performance.
