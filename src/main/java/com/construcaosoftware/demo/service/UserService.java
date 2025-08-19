package com.construcaosoftware.demo.service;

import com.construcaosoftware.demo.dtos.UserDto;
import com.construcaosoftware.demo.entity.UserEntity;
import com.construcaosoftware.demo.repository.UserRepository;
import com.construcaosoftware.demo.config.UserMapper;
import lombok.AllArgsConstructor;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.NoSuchElementException;


@AllArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;

    private final UserMapper userMapper;

    public UserDto createUser(@RequestBody UserDto userDto) {
        try {
            UserEntity newUser = userMapper.toEntity(userDto);
            UserEntity createdUser = userRepository.save(newUser);
            return userDto;
        } catch (DataIntegrityViolationException e) {
            throw new RuntimeException("Error saving user", e);
        }
    }

    public UserDto getUser(@PathVariable Long id) {
        UserEntity userEntity = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User not found with id " + id));
        return userMapper.toDto(userEntity);
    }


    public UserDto updateUser(@PathVariable Long id, @RequestBody UserDto userDto) {
        try {
            UserEntity updatedUser = userRepository.findById(id).get();

            UserEntity newData = userMapper.toEntity(userDto);

            updatedUser.setFirstName(newData.getFirstName());
            updatedUser.setLastName(newData.getLastName());
            updatedUser.setDocument(newData.getDocument());
            updatedUser.setBirthday(newData.getBirthday());
            updatedUser.setEmail(newData.getEmail());

            userRepository.save(updatedUser);

            return userMapper.toDto(updatedUser);
        } catch (NoSuchElementException e) {
            throw new NoSuchElementException("User not found with id " + id);
        }
    }

    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new NoSuchElementException("User not found with id " + id);
        }
        userRepository.deleteById(id);
    }
}
