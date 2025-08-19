package com.construcaosoftware.demo.config;

import com.construcaosoftware.demo.dtos.UserDto;
import com.construcaosoftware.demo.entity.UserEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {

    UserDto toDto(UserEntity userEntity);
    UserEntity toEntity(UserDto userDto);
}
