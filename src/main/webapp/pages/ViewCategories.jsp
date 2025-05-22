<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<!-- Display message if there is any -->
    <c:choose>
        <c:when test="${not empty errorMessage}">
            <div class="alert alert-${messageType}" role="alert">
                ${errorMessage}
            </div>
        </c:when>
    </c:choose>  

        <h2 class="mb-4">Available Categories</h2>

        <ul class="list-group">
            <c:forEach var="category" items="${categories}">
                <li class="list-group-item">${category.name}</li>
            </c:forEach>
        </ul>

                    <!-- Category Table -->
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="thead-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="category" items="${categories}">
                                    <tr>
                                        <td>${category.categoryId}</td>
                                        <td>${category.name}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty category.description}">
                                                    ${category.description}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">No description</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <!-- Edit Button -->
                                            <button class="btn btn-sm btn-warning" data-bs-toggle="modal" 
                                                    data-bs-target="#editModal${category.categoryId}">
                                                <i class="bi bi-pencil"></i> Edit
                                            </button>
                                            
                                            <!-- Delete Form -->
                                            <form action="${pageContext.request.contextPath}/CategoryController" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="categoryId" value="${category.categoryId}">
                                                <button type="submit" class="btn btn-sm btn-danger" 
                                                        onclick="return confirm('Are you sure? This will delete ${category.name} category')">
                                                    <i class="bi bi-trash"></i> Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    
                                    <!-- Edit Modal -->
                                    <div class="modal fade" id="editModal${category.categoryId}" tabindex="-1">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Edit Category: ${category.name}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/CategoryController" method="post">
                                                    <div class="modal-body">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="categoryId" value="${category.categoryId}">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Name</label>
                                                                    <input type="text" class="form-control" 
                                                                           name="categoryName" value="${category.name}" required>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Description</label>
                                                                    <textarea class="form-control" 
                                                                              name="categoryDescription" rows="3">${category.description}</textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
</body>
</html>