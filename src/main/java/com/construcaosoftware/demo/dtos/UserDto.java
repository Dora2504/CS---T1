package com.construcaosoftware.demo.dtos;

import lombok.Data;

@Data
public class UserDto {

    private Long userId;
    private String firstName;
    private String lastName;
    private String document;
    private String birthday;
    private String email;
}
